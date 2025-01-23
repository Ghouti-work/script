#!/bin/bash

# Function to display usage
usage() {
    cat <<EOF
Usage: git_workflow [COMMAND]

Commands:
  init              Initialize a new Git repository
  add-remote        Add a remote repository
  pull              Pull changes from the remote repository
  push              Push changes to the remote repository
  resolve-conflict  Resolve conflicts using nvim
  man               Display this help message

Examples:
  git_workflow init
  git_workflow add-remote
  git_workflow pull
  git_workflow push
  git_workflow resolve-conflict
EOF
}

# Ensure the script is run with an argument
if [ $# -lt 1 ]; then
    usage
    exit 1
fi

# Function to initialize a new Git repository
init_repo() {
    git init
    echo "Initialized empty Git repository"
}

# Function to add a remote repository
add_remote() {
    read -p "Enter remote URL: " remote_url
    git remote add origin $remote_url
    echo "Remote 'origin' added with URL $remote_url"
}

# Function to pull changes from the remote repository
pull_changes() {
    git pull origin main --rebase
}

# Function to push changes to the remote repository
push_changes() {
    git push --set-upstream origin main
}

# Function to resolve conflicts
resolve_conflict() {
    nvim $(git diff --name-only --diff-filter=U)
    git add .
    git rebase --continue
}

# Main script logic
case $1 in
    init)
        init_repo
        ;;
    add-remote)
        add_remote
        ;;
    pull)
        pull_changes
        ;;
    push)
        push_changes
        ;;
    resolve-conflict)
        resolve_conflict
        ;;
    man)
        usage
        ;;
    *)
        usage
        ;;
esac

exit 0
