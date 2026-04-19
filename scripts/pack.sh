#!/usr/bin/env bash
# pack.sh — zip a directory into a .hpk file
#
# Usage:
#   bash scripts/pack.sh <source-directory> [output.hpk]
#
# If output is omitted, the .hpk is created in the current directory
# named after the source directory (e.g. examples/content-creator -> content-creator.hpk).
#
# Preserves file permissions. Excludes .DS_Store and __pycache__.

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: bash scripts/pack.sh <source-directory> [output.hpk]" >&2
    exit 1
fi

SOURCE_DIR="${1%/}"  # strip trailing slash

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: '$SOURCE_DIR' is not a directory." >&2
    exit 1
fi

if [[ ! -f "$SOURCE_DIR/workspace.yml" ]]; then
    echo "ERROR: '$SOURCE_DIR/workspace.yml' not found. Is this an HPK workspace?" >&2
    exit 1
fi

BASENAME="$(basename "$SOURCE_DIR")"
OUTPUT="${2:-${BASENAME}.hpk}"

# Build inside a temp dir so we get clean relative paths in the zip
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cp -a "$SOURCE_DIR/." "$TMPDIR/"

# Remove junk
find "$TMPDIR" -name ".DS_Store" -delete
find "$TMPDIR" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
find "$TMPDIR" -name "*.pyc" -delete 2>/dev/null || true

# Create the zip
(cd "$TMPDIR" && zip -r - . --exclude "*.git*") > "$OUTPUT"

echo "Packed: $OUTPUT ($(du -sh "$OUTPUT" | cut -f1))"
