#!/bin/bash
# commit_show.sh: Generates an HTML page showing details for a single commit.
# Usage: commit_show.sh <commit-hash>

if [ -z "$1" ]; then
  echo "Usage: commit_show.sh <commit-hash>"
  exit 1
fi

COMMIT_HASH="$1"

# Ensure we're in a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: Not inside a Git repository."
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$BASE_DIR/templates"

# Create a temporary HTML file for the commit view
OUTPUT_FILE=$(mktemp /tmp/git_viewer_commit_show_XXXXXX.html)

COMMIT_INFO=$(git show --quiet --pretty=format:'%h%n%an%n%ad%n%s' "$COMMIT_HASH")
COMMIT_DIFF=$(git diff "$COMMIT_HASH^" "$COMMIT_HASH")

# Merge header, commit_show template (with placeholders), and footer
cat "$TEMPLATES_DIR/header.html" > "$OUTPUT_FILE"

cat "$TEMPLATES_DIR/commit_show.html" | \
  sed "s|{{COMMIT_HASH}}|$COMMIT_HASH|g" | \
  sed "s|{{COMMIT_INFO}}|$(echo "$COMMIT_INFO" | sed 's|&|\&amp;|g; s|<|\&lt;|g; s|>|\&gt;|g')|g" | \
  sed "s|{{COMMIT_DIFF}}|$(echo "$COMMIT_DIFF" | sed 's|&|\&amp;|g; s|<|\&lt;|g; s|>|\&gt;|g')|g" \
  >> "$OUTPUT_FILE"

cat "$TEMPLATES_DIR/footer.html" >> "$OUTPUT_FILE"

echo "Generated commit show: $OUTPUT_FILE"
xdg-open "$OUTPUT_FILE" 2>/dev/null || open "$OUTPUT_FILE" 2>/dev/null
