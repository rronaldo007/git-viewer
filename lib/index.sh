#!/bin/bash
# index.sh: Generates the main index page that links to commits and pull requests.

# Ensure we're in a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: Not inside a Git repository."
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$BASE_DIR/templates"

# Prepare a temporary file for the index page
INDEX_FILE=$(mktemp /tmp/git_viewer_index_XXXXXX.html)

# Merge the template files: header, index, footer
cat "$TEMPLATES_DIR/header.html" > "$INDEX_FILE"
cat "$TEMPLATES_DIR/index.html" >> "$INDEX_FILE"
cat "$TEMPLATES_DIR/footer.html" >> "$INDEX_FILE"

echo "Generated index: $INDEX_FILE"
# Open in default browser
xdg-open "$INDEX_FILE" 2>/dev/null || open "$INDEX_FILE" 2>/dev/null
