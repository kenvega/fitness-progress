#!/usr/bin/env bash
set -euo pipefail

METRICS_DIR=".metrics"
FILE="$METRICS_DIR/encrypted_files_added_total.txt"
mkdir -p "$METRICS_DIR"

# current total (default 0)
if [[ -s "$FILE" ]]; then
  total=$(<"$FILE")
  [[ "$total" =~ ^[0-9]+$ ]] || total=0
else
  total=0
fi

# files ADDED under encrypted/ in this commit
added_files=$(git diff --cached --name-only --diff-filter=A -- 'encrypted/*' | wc -l | tr -d ' ')
added_files=$((added_files+0))

# convert to groups of 3
groups=$(( added_files / 3 ))

# if no full group of 3, exit quietly
[[ "$groups" -eq 0 ]] && exit 0

new_total=$(( total + groups ))
echo "$new_total" > "$FILE"

echo "Encrypted files added: $added_files  | Counted groups of 3: $groups | New total → $new_total"

git add "$FILE"
