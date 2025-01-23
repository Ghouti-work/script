#!/bin/bash

# Rofi and GitHub CLI project launcher script

# Menu options
options="1. Create New Project\n2. Clone Existing Project\n3. Exit"

# Show menu using rofi
choice=$(echo -e "$options" | rofi -dmenu -i -p "Select an Action:")

case "$choice" in
"1. Create New Project")
  # Prompt for project name, description, and visibility
  PROJECT_NAME=$(rofi -dmenu -p "Enter project name:")
  PROJECT_DESCRIPTION=$(rofi -dmenu -p "Enter project description:")
  VISIBILITY=$(echo -e "public\nprivate" | rofi -dmenu -p "Set visibility:")

  # Create directory and initialize Git
  mkdir "$PROJECT_NAME"
  cd "$PROJECT_NAME" || exit
  git init

  # Add README and .gitignore
  echo "# $PROJECT_NAME" >README.md
  echo "node_modules/\n.env\nbuild/" >.gitignore
  git add .
  git commit -m "Initial commit"

  # Use GitHub CLI to create a repo
  gh repo create "$PROJECT_NAME" --description "$PROJECT_DESCRIPTION" --$VISIBILITY --source=. --push

  rofi -e "Project '$PROJECT_NAME' created and pushed to GitHub."
  ;;

"2. Clone Existing Project")
  # Prompt for repo URL
  REPO_URL=$(rofi -dmenu -p "Enter GitHub repository URL:")
  git clone "$REPO_URL"
  rofi -e "Repository cloned successfully."
  ;;

"3. Exit")
  exit 0
  ;;

*)
  rofi -e "Invalid choice. Exiting."
  ;;
esac
