#!/bin/bash
# pr_list.sh: Generates an HTML page listing the last 20 pull requests via GitHub CLI (gh).

# Ensure GitHub CLI is installed
if ! command -v gh &>/dev/null; then
  echo "GitHub CLI (gh) is not installed. Cannot list pull requests."
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$BASE_DIR/templates"

OUTPUT_FILE=$(mktemp /tmp/git_viewer_pr_list_XXXXXX.html)

cat "$TEMPLATES_DIR/header.html" > "$OUTPUT_FILE"
cat "$TEMPLATES_DIR/pr_list.html" >> "$OUTPUT_FILE"

{
  echo '<div class="list-group mt-3">'
  if ! command -v jq &>/dev/null; then
    echo "<p>Warning: 'jq' is not installed. Raw JSON output below:</p>"
    echo '<pre>'
    gh pr list --limit 20 --json title,number,author,createdAt,state
    echo '</pre>'
  else
    gh pr list --limit 20 --json title,number,author,createdAt,state | \
    jq -r '.[] | "\(.number)|\(.title)|\(.author.login)|\(.createdAt)|\(.state)"' | \
    while IFS='|' read -r number title author createdAt state; do
      echo "  <a href=\"#\" class=\"list-group-item list-group-item-action\" onclick=\"window.location.href='pr_show_$number.html'\">"
      echo "    <strong>PR #$number</strong> - $title<br>"
      echo "    <small>$author, $createdAt, $state</small>"
      echo "  </a>"
    done
  fi
  echo '</div>'
} >> "$OUTPUT_FILE"

cat "$TEMPLATES_DIR/footer.html" >> "$OUTPUT_FILE"

echo "Generated PR list: $OUTPUT_FILE"
xdg-open "$OUTPUT_FILE" 2>/dev/null || open "$OUTPUT_FILE" 2>/dev/null
