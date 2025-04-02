#!/bin/bash
# pr_show.sh: Generates an HTML page showing details for a single pull request.
# Usage: pr_show.sh <pr-number>

if [ -z "$1" ]; then
  echo "Usage: pr_show.sh <pr-number>"
  exit 1
fi

PR_NUMBER="$1"

# Ensure GitHub CLI is installed
if ! command -v gh &>/dev/null; then
  echo "GitHub CLI (gh) is not installed. Cannot show pull requests."
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$BASE_DIR/templates"

OUTPUT_FILE=$(mktemp /tmp/git_viewer_pr_show_XXXXXX.html)

PR_DETAIL=$(gh pr view "$PR_NUMBER" --json title,number,author,body,createdAt,state)
escaped_detail=$(echo "$PR_DETAIL" | sed 's|&|\&amp;|g; s|<|\&lt;|g; s|>|\&gt;|g')

cat "$TEMPLATES_DIR/header.html" > "$OUTPUT_FILE"

cat "$TEMPLATES_DIR/pr_show.html" | \
  sed "s|{{PR_NUMBER}}|$PR_NUMBER|g" | \
  sed "s|{{PR_DETAIL}}|$escaped_detail|g" \
  >> "$OUTPUT_FILE"

cat "$TEMPLATES_DIR/footer.html" >> "$OUTPUT_FILE"

echo "Generated PR show: $OUTPUT_FILE"
xdg-open "$OUTPUT_FILE" 2>/dev/null || open "$OUTPUT_FILE" 2>/dev/null
