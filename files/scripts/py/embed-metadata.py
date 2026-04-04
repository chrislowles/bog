#!/usr/bin/env python3
"""
embed-metadata.py

Scans a directory for yt-dlp-downloaded videos that are missing embedded
metadata, fetches the metadata without redownloading, and embeds it in-place.

Supports YouTube and Internet Archive sources.

Requirements: yt-dlp, ffmpeg, ffprobe (all on PATH)
Python: 3.10+

Usage:
    python embed-metadata.py /path/to/videos
    python embed-metadata.py /path/to/videos --dry-run
    python embed-metadata.py /path/to/videos --check-field comment
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

# ── Config ────────────────────────────────────────────────────────────────────

VIDEO_EXTENSIONS = {".mp4", ".mkv", ".webm", ".avi", ".mov", ".flv", ".m4v", ".ts"}

# YouTube IDs are exactly 11 characters: alphanumeric, hyphen, underscore
YOUTUBE_ID_RE = re.compile(r"\[([A-Za-z0-9_-]{11})\]")

# Anything in brackets that isn't a YouTube ID is treated as an IA identifier
BRACKET_RE = re.compile(r"\[([^\]]+)\]")

# ── Metadata detection ─────────────────────────────────────────────────────────

def has_metadata(path: Path, check_field: str = "title") -> bool:
    """
    Returns True if the video has the given tag embedded.
    Defaults to checking 'title', which yt-dlp always sets when --embed-metadata is used.
    On ffprobe failure, returns True (safe default — skip rather than double-process).
    """
    try:
        result = subprocess.run(
            ["ffprobe", "-v", "quiet", "-print_format", "json", "-show_format", str(path)],
            capture_output=True,
            text=True,
            timeout=30,
        )
        data = json.loads(result.stdout)
        tags = {k.lower(): v for k, v in data.get("format", {}).get("tags", {}).items()}
        return check_field.lower() in tags
    except Exception as e:
        print(f"  [warn] ffprobe failed for {path.name}: {e}")
        return True  # Err on the side of caution


# ── ID / URL extraction ────────────────────────────────────────────────────────

def extract_url(stem: str) -> str | None:
    """
    Attempts to reconstruct the source URL from a filename stem.
    Returns a YouTube or Internet Archive URL, or None if no ID found.
    """
    # Prefer the rightmost bracketed group (yt-dlp puts ID at the end)
    all_brackets = BRACKET_RE.findall(stem)
    if not all_brackets:
        return None

    for candidate in reversed(all_brackets):
        # YouTube: exactly 11 chars, restricted charset
        if re.fullmatch(r"[A-Za-z0-9_-]{11}", candidate):
            return f"https://www.youtube.com/watch?v={candidate}"

    # No YouTube ID found — use the last bracketed group as an IA identifier
    ia_id = all_brackets[-1]
    return f"https://archive.org/details/{ia_id}"


# ── Metadata fetching ──────────────────────────────────────────────────────────

def fetch_info_json(url: str, tmp_dir: Path) -> dict | None:
    """
    Runs yt-dlp --skip-download --write-info-json --write-thumbnail and returns
    the parsed dict, or None on failure. Thumbnail is saved into tmp_dir as a
    side effect.
    """
    try:
        subprocess.run(
            [
                "yt-dlp",
                "--skip-download",
                "--write-info-json",
                "--write-thumbnail",
                "--no-playlist",
                "--no-warnings",
                "-o", str(tmp_dir / "%(id)s.%(ext)s"),
                url,
            ],
            capture_output=True,
            text=True,
            timeout=60,
        )
    except subprocess.TimeoutExpired:
        print("  [warn] yt-dlp timed out")
        return None
    except FileNotFoundError:
        print("  [error] yt-dlp not found on PATH")
        sys.exit(1)

    json_files = list(tmp_dir.glob("*.info.json"))
    if not json_files:
        return None

    try:
        with open(json_files[0]) as f:
            return json.load(f)
    except Exception as e:
        print(f"  [warn] Could not parse info.json: {e}")
        return None


def find_thumbnail(tmp_dir: Path) -> Path | None:
    """Returns the first image file in tmp_dir, or None."""
    for ext in (".jpg", ".jpeg", ".png", ".webp"):
        matches = list(tmp_dir.glob(f"*{ext}"))
        if matches:
            return matches[0]
    return None


# ── Metadata embedding ─────────────────────────────────────────────────────────

# Maps yt-dlp info.json fields → ffmpeg metadata tag names
INFO_FIELD_MAP = {
    "title":       "title",
    "uploader":    "artist",
    "description": "comment",
    "webpage_url": "purl",        # Permanent URL — supported in MP4/MKV
}


def format_date(upload_date: str) -> str:
    """Converts yt-dlp's YYYYMMDD to YYYY-MM-DD."""
    if len(upload_date) == 8 and upload_date.isdigit():
        return f"{upload_date[:4]}-{upload_date[4:6]}-{upload_date[6:8]}"
    return upload_date


def build_metadata_args(info: dict) -> list[str]:
    """Returns a flat list of -metadata key=value ffmpeg arguments."""
    args = []
    for info_key, ffmpeg_key in INFO_FIELD_MAP.items():
        value = info.get(info_key)
        if value:
            args += ["-metadata", f"{ffmpeg_key}={value}"]

    upload_date = info.get("upload_date")
    if upload_date:
        args += ["-metadata", f"date={format_date(upload_date)}"]

    return args


def embed_metadata(video: Path, info: dict, thumbnail: Path | None = None) -> bool:
    """
    Embeds metadata (and optionally a thumbnail) into a video file in-place.
    Writes to a temp file in the same directory, then atomically replaces the original.

    Thumbnail support:
      MP4/M4V  — embedded as a cover art video stream (attached_pic)
      MKV      — embedded as a file attachment
      WebM     — not supported; thumbnail skipped with a warning
    Returns True on success.
    """
    meta_args = build_metadata_args(info)
    if not meta_args:
        print("  [warn] No usable metadata fields found in info.json")
        return False

    ext = video.suffix.lower()
    tmp_path = video.with_suffix(f".tmp{video.suffix}")

    if thumbnail and ext == ".webm":
        print("  [info] WebM does not support embedded thumbnails — skipping thumbnail")
        thumbnail = None

    try:
        if thumbnail and ext in (".mp4", ".m4v"):
            # MP4: add thumbnail as a second input, map both streams, flag as cover art
            cmd = [
                "ffmpeg", "-y",
                "-i", str(video),
                "-i", str(thumbnail),
                "-map", "0",
                "-map", "1",
                "-c", "copy",
                "-disposition:v:1", "attached_pic",
            ] + meta_args + [str(tmp_path)]

        elif thumbnail and ext == ".mkv":
            # MKV: attach the image file directly
            mime = "image/jpeg" if thumbnail.suffix.lower() in (".jpg", ".jpeg") else "image/png"
            cmd = [
                "ffmpeg", "-y",
                "-i", str(video),
                "-c", "copy",
                "-attach", str(thumbnail),
                f"-metadata:s:t:0", f"mimetype={mime}",
                f"-metadata:s:t:0", "filename=cover.jpg",
            ] + meta_args + [str(tmp_path)]

        else:
            # No thumbnail (either unavailable or unsupported format)
            cmd = ["ffmpeg", "-y", "-i", str(video)] + meta_args + ["-c", "copy", str(tmp_path)]

        result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)

        if result.returncode != 0:
            print(f"  [warn] ffmpeg error:\n{result.stderr[-500:]}")
            tmp_path.unlink(missing_ok=True)
            return False

        shutil.move(str(tmp_path), str(video))
        return True

    except subprocess.TimeoutExpired:
        print("  [warn] ffmpeg timed out")
        tmp_path.unlink(missing_ok=True)
        return False
    except FileNotFoundError:
        print("  [error] ffmpeg not found on PATH")
        sys.exit(1)
    except Exception as e:
        print(f"  [warn] Unexpected error during embedding: {e}")
        tmp_path.unlink(missing_ok=True)
        return False


# ── Main logic ─────────────────────────────────────────────────────────────────

def process_directory(root: Path, dry_run: bool, check_field: str):
    videos = sorted(p for p in root.rglob("*") if p.suffix.lower() in VIDEO_EXTENSIONS)

    if not videos:
        print(f"No video files found under {root}")
        return

    print(f"Found {len(videos)} video file(s). Checking for embedded metadata...\n")

    needs_metadata = []
    for v in videos:
        if not has_metadata(v, check_field):
            needs_metadata.append(v)

    already_done = len(videos) - len(needs_metadata)
    print(f"  {already_done} already have metadata — skipping")
    print(f"  {len(needs_metadata)} need metadata embedded\n")

    if not needs_metadata:
        print("Nothing to do.")
        return

    if dry_run:
        print("Dry run — files that would be processed:")
        for v in needs_metadata:
            url = extract_url(v.stem)
            url_str = url if url else "(no ID found — manual intervention needed)"
            print(f"  {v.name}")
            print(f"    → {url_str}")
        return

    # ── Processing loop ────────────────────────────────────────────────────────

    succeeded = []
    failed = []
    no_id = []

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir)

        for v in needs_metadata:
            print(f"▶ {v.name}")

            url = extract_url(v.stem)
            if not url:
                print("  → No video ID in filename. Flagged for manual intervention.\n")
                no_id.append(v)
                continue

            print(f"  → {url}")

            # Clear tmp dir between files
            for f in tmp.iterdir():
                f.unlink()

            info = fetch_info_json(url, tmp)
            if not info:
                print("  → Failed to fetch metadata (video may be unavailable or private).")
                failed.append((v, url))
                print()
                continue

            print(f"  → Fetched: \"{info.get('title', '(untitled)')}\"")

            thumbnail = find_thumbnail(tmp)
            if thumbnail:
                print(f"  → Thumbnail: {thumbnail.name}")
            else:
                print("  → No thumbnail downloaded")

            if embed_metadata(v, info, thumbnail):
                print("  ✓ Metadata embedded successfully.\n")
                succeeded.append(v)
            else:
                print("  ✗ Embedding failed.\n")
                failed.append((v, url))

    # ── Summary ────────────────────────────────────────────────────────────────

    print("─" * 60)
    print(f"Done.  {len(succeeded)} succeeded  |  {len(failed)} failed  |  {len(no_id)} need manual attention")

    if no_id:
        print(f"\nFiles with no ID in filename ({len(no_id)}):")
        print("  To process these, rename them to include the video ID in brackets,")
        print("  e.g.  'My Video [dQw4w9WgXcQ].mp4'  (YouTube)")
        print("  or    'My Video [archive-identifier].mp4'  (Internet Archive)")
        for v in no_id:
            print(f"  • {v}")

    if failed:
        print(f"\nFailed ({len(failed)}):")
        for v, url in failed:
            print(f"  • {v.name}")
            print(f"    {url}")


# ── Entry point ────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Embed metadata into yt-dlp videos that are missing it.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python embed-metadata.py ~/Videos
  python embed-metadata.py ~/Videos --dry-run
  python embed-metadata.py ~/Videos --check-field comment
        """,
    )
    parser.add_argument("directory", help="Root directory to scan (searched recursively)")
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="List files that would be processed without making any changes",
    )
    parser.add_argument(
        "--check-field",
        default="title",
        metavar="TAG",
        help="ffmpeg tag name to check for presence of existing metadata (default: title)",
    )
    args = parser.parse_args()

    root = Path(args.directory).resolve()
    if not root.is_dir():
        print(f"Error: '{root}' is not a directory.")
        sys.exit(1)

    process_directory(root, dry_run=args.dry_run, check_field=args.check_field)


if __name__ == "__main__":
    main()