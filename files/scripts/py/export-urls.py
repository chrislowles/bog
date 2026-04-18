#!/usr/bin/env python3
"""
export-urls.py

Walks a directory of yt-dlp-downloaded videos, extracts YouTube or Internet Archive IDs from filenames, and writes a plain-text URL list compatible with Parabolic's Batch File feature (one URL per line).

Usage:
    python export-urls.py /path/to/videos
    python export-urls.py /path/to/videos -o my-urls.txt
"""

import argparse
import re
import sys
from pathlib import Path

VIDEO_EXTENSIONS = {".mp4", ".mkv", ".webm", ".avi", ".mov", ".flv", ".m4v", ".ts"}

BRACKET_RE = re.compile(r"\[([^\]]+)\]")


def extract_url(stem: str) -> str | None:
    all_brackets = BRACKET_RE.findall(stem)
    if not all_brackets:
        return None

    for candidate in reversed(all_brackets):
        if re.fullmatch(r"[A-Za-z0-9_-]{11}", candidate):
            return f"https://www.youtube.com/watch?v={candidate}"

    # Fall back to last bracketed group as an Internet Archive identifier
    return f"https://archive.org/details/{all_brackets[-1]}"

def main():
    parser = argparse.ArgumentParser(
        description="Export video URLs from filenames to a Parabolic-compatible list."
    )
    parser.add_argument("directory", help="Directory to scan (recursive)")
    parser.add_argument(
        "-o", "--output",
        default="batch-file.txt",
        help="Output file path (default: batch-file.txt in current directory)",
    )
    args = parser.parse_args()

    root = Path(args.directory).resolve()
    if not root.is_dir():
        print(f"Error: '{root}' is not a directory.")
        sys.exit(1)

    videos = sorted(p for p in root.rglob("*") if p.suffix.lower() in VIDEO_EXTENSIONS)
    if not videos:
        print("No video files found.")
        sys.exit(0)

    urls = []
    no_id = []

    for v in videos:
        url = extract_url(v.stem)
        if url:
            urls.append(url)
        else:
            no_id.append(v)

    output = Path(args.output)
    output.write_text("\n".join(urls) + "\n")

    print(f"Wrote {len(urls)} URL(s) to {output}")

    if no_id:
        print(f"\n{len(no_id)} file(s) had no ID in filename and were skipped:")
        for v in no_id:
            print(f"  - {v.name}")


if __name__ == "__main__":
    main()