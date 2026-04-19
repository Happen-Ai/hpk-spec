#!/usr/bin/env bash
# ots-stamp.sh — create an OpenTimestamps proof of existence for the latest git commit
#
# What is OpenTimestamps?
# -----------------------
# OpenTimestamps (https://opentimestamps.org) is a free, open-source protocol
# that creates a cryptographic proof that a piece of data existed at a given
# point in time, by embedding its hash into the Bitcoin blockchain.
#
# A .ots file is a "receipt" you keep. Anyone can verify it later with:
#   ots verify <file>.ots
#
# For this repo, stamping a commit hash provides legally useful evidence
# that the HPK specification existed as of that timestamp — useful for:
#   - Patent priority disputes
#   - Trademark "date of first use" evidence
#   - Proving prior art
#
# Usage:
#   bash scripts/ots-stamp.sh
#
# Output:
#   Creates <commit-hash>.ots in the current directory.
#   Upload this file to the repo (e.g. stamps/) for permanent record.
#
# Requirements:
#   ots CLI: pip install opentimestamps-client
#   Or: brew install opentimestamps-client

set -euo pipefail

if ! command -v ots &>/dev/null; then
    echo "ERROR: 'ots' not found." >&2
    echo "Install with: pip install opentimestamps-client" >&2
    echo "         or: brew install opentimestamps-client" >&2
    exit 1
fi

COMMIT_HASH="$(git log -1 --format=%H)"
if [[ -z "$COMMIT_HASH" ]]; then
    echo "ERROR: Not in a git repo or no commits found." >&2
    exit 1
fi

STAMP_FILE="${COMMIT_HASH}.ots"

if [[ -f "$STAMP_FILE" ]]; then
    echo "WARNING: $STAMP_FILE already exists. Not re-stamping (timestamps are one-shot)." >&2
    exit 1
fi

echo "Latest commit: $COMMIT_HASH"
echo "Stamping to Bitcoin blockchain via OpenTimestamps..."

# Write the commit hash to a temp file and stamp it
TMPFILE="$(mktemp)"
echo "$COMMIT_HASH" > "$TMPFILE"
trap 'rm -f "$TMPFILE" "${TMPFILE}.ots"' EXIT

ots stamp "$TMPFILE"
mv "${TMPFILE}.ots" "$STAMP_FILE"

echo ""
echo "Created: $STAMP_FILE"
echo ""
echo "IMPORTANT:"
echo "  1. Commit this .ots file to the repo: git add $STAMP_FILE && git commit -s -m 'ots: stamp commit $COMMIT_HASH'"
echo "  2. The proof will be confirmed in ~1 hour once mined into Bitcoin."
echo "  3. Verify later with: ots verify $STAMP_FILE"
echo "  4. Never re-stamp the same commit — it won't improve the proof and wastes calendar server resources."
