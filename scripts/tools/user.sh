#!/bin/bash

# Define some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# The category to display
category=$1

# If no category is provided, list all categories
if [[ -z $category ]]; then
    echo -e "${YELLOW}Categories:${NC}"
    grep -oP '(?<=# Category: ).*' ~/.zshrc
    exit 0
fi

# Read the .zshrc file line by line
while IFS= read -r line; do
    # If the line starts with "# Category:", it's a category definition
    if [[ $line == "# Category:"* ]]; then
        current_category=$(echo $line | cut -d':' -f 2 | tr -d ' ')
        
    # If the line starts with "alias", it's an alias definition
    elif [[ $line == alias* ]]; then
        # If the current category is the one we're looking for, print the alias
        if [[ $current_category == $category ]]; then
            # Extract the alias name
            alias_name=$(echo $line | awk -F'=' '{print $1}' | awk '{print $2}')

            # Extract the alias command
            alias_command=$(echo $line | cut -d'=' -f 2- | tr -d "'")

            # Print the alias name and command with colors
            echo -e "${RED}Alias: ${GREEN}$alias_name${NC}"
            echo -e "${RED}Command: ${BLUE}$alias_command${NC}"
            echo ""
        fi
    fi
done < ~/.zshrc

