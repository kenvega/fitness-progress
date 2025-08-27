#!/usr/bin/env bash
# scripts/encrypt_files.sh — run from your repo root

set -euo pipefail

read -s -p "Password: " PASS; echo

# Walk all files under original/, preserve tree, skip if encrypted copy exists
find original -type f -print0 | while IFS= read -r -d '' SRC; do
  REL="${SRC#original/}"                  # e.g., 2025-08/photo.jpg
  DEST="encrypted/${REL}.enc"             # e.g., encrypted/2025-08/photo.jpg.enc

  if [ -f "$DEST" ]; then
    echo "skip: $REL"
    continue
  fi

  mkdir -p "$(dirname "$DEST")"
  openssl enc -aes-256-cbc -salt -pbkdf2 -iter 200000 \
    -in "$SRC" -out "$DEST" \
    -pass pass:"$PASS"

  echo "encrypted: $REL"
done

echo "done."