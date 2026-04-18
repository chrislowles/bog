#!/usr/bin/env python3
import os, re, subprocess
from datetime import datetime, timezone

# Only filenames we know actually use Unix ms timestamps
KNOWN_PREFIXES = ('FB_IMG_', 'received_', 'Snapchat-', 'Messenger_creation_')

# Reasonable bounds — nothing before 2000 or after today
YEAR_MIN = 2000
YEAR_MAX = 2026

pattern = re.compile(r'(\d{13})')

skipped = []

for fname in os.listdir('.'):
    if not fname.startswith(KNOWN_PREFIXES):
        continue

    m = pattern.search(fname)
    if not m:
        skipped.append((fname, 'no 13-digit number found'))
        continue

    ts_ms = int(m.group(1))
    dt = datetime.fromtimestamp(ts_ms / 1000, tz=timezone.utc)

    if not (YEAR_MIN <= dt.year <= YEAR_MAX):
        skipped.append((fname, f'date out of range: {dt.year}'))
        continue

    exif_date = dt.strftime('%Y:%m:%d %H:%M:%S')
    subprocess.run([
        'exiftool', '-overwrite_original',
        f'-DateTimeOriginal={exif_date}',
        fname
    ])
    print(f'SUCCESS: {fname} > {exif_date}')

if skipped:
    print('\nSkipped:')
    for fname, reason in skipped:
        print(f'  {fname}: {reason}')