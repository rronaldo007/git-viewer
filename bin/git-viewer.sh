#!/bin/bash
# git-viewer.sh: Main entry point for the Git Viewer.
# No arguments needed: it auto-detects the current Git repository and generates an index page.

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$BASE_DIR/lib"

# Run the index script to generate and open the main page
"$LIB_DIR/index.sh"
