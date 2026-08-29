#!/usr/bin/env bash
# Copy official htmx agent skills into skills/<name>/SKILL.md.
#
# Usage:
#   scripts/sync.sh              # use UPSTREAM ref, or v4.0.0
#   scripts/sync.sh v4.0.0
#   scripts/sync.sh master
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

REPO="${HTMX_REPO:-bigskysoftware/htmx}"
PATH_IN_REPO="${HTMX_SKILLS_PATH:-dist/skills}"
DEFAULT_REF="v4.0.0"

if [[ -n "${1:-}" ]]; then
  REF="$1"
elif [[ -f UPSTREAM ]]; then
  REF="$(awk -F= '/^ref=/{print $2; exit}' UPSTREAM)"
fi
REF="${REF:-$DEFAULT_REF}"

API_URL="https://api.github.com/repos/${REPO}/contents/${PATH_IN_REPO}?ref=${REF}"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${REF}/${PATH_IN_REPO}"

echo "Syncing official skills from ${REPO}@${REF}:${PATH_IN_REPO}"

LISTING="$(curl -fsSL -H "Accept: application/vnd.github+json" "$API_URL")"
FILES_JSON="$(python3 -c '
import json, sys
data = json.load(sys.stdin)
if not isinstance(data, list):
    raise SystemExit("unexpected GitHub API response")
names = sorted(
    item["name"]
    for item in data
    if item.get("type") == "file" and str(item.get("name", "")).endswith(".md")
)
if not names:
    raise SystemExit("no .md skill files found upstream")
print("\n".join(names))
' <<<"$LISTING")"

mapfile -t FILES <<<"$FILES_JSON"

mkdir -p skills
for file in "${FILES[@]}"; do
  name="${file%.md}"
  dest="skills/${name}/SKILL.md"
  mkdir -p "skills/${name}"
  echo "  $file -> $dest"
  curl -fsSL "${RAW_BASE}/${file}" -o "$dest"
done

shopt -s nullglob
for dir in skills/*/; do
  name="$(basename "$dir")"
  keep=0
  for file in "${FILES[@]}"; do
    if [[ "${file%.md}" == "$name" ]]; then
      keep=1
      break
    fi
  done
  if [[ "$keep" -eq 0 ]]; then
    echo "  removing stale $dir"
    rm -rf "$dir"
  fi
done

{
  echo "repo=https://github.com/${REPO}"
  echo "ref=${REF}"
  echo "path=${PATH_IN_REPO}"
  echo "synced_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "files=${FILES[*]}"
} > UPSTREAM

echo "Wrote UPSTREAM"
echo "Done."
