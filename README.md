# git-viewer# Git Viewer - Interactive Git Repository Browser

Git Viewer is a lightweight, extensible tool designed to provide an interactive, Bootstrap-powered web interface for exploring your Git repository. It automatically detects the current Git repository and allows you to view both commit and pull request information—both as lists and in detailed individual views.

## Features

- **Index Page**: A clean landing page that offers navigation to:
  - **Commits**: View a list of the last 20 commits. Click any commit to see detailed information and diffs.
  - **Pull Requests**: (Requires GitHub CLI) View a list of up to 20 pull requests. Click any PR to view its details.
- **Individual Views**:
  - **Commit Details**: Display commit metadata, author info, and full diff.
  - **Pull Request Details**: Show raw JSON details (fetched via the GitHub CLI) for a selected pull request.
- **Modern UI**: Built with [Bootstrap 5](https://getbootstrap.com/) for a responsive and intuitive design.
- **Extensible Architecture**: Modular file structure for easy enhancements and future improvements.

## Prerequisites

- **Git**: The repository to be viewed must be a valid Git repository.
- **GitHub CLI (gh)**: Required for pull request functionality. [Install GitHub CLI](https://cli.github.com/) if you want to view pull requests.
- **jq** (optional): Used for parsing JSON output from GitHub CLI. If not installed, PR details will be shown as raw JSON.
- **A web browser**: The tool automatically opens the generated HTML in your default browser.

## Installation

1. **Clone or copy the repository**:
   - Place the entire `git-viewer` folder into the root of your Git repository.
2. **Set executable permissions**:
   ```bash
   cd git-viewer
   chmod +x bin/git-viewer.sh lib/*.sh
