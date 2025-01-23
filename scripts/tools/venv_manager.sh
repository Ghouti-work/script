#!/bin/bash

# Function to create a virtual environment
create_venv() {
    if [ -z "$1" ]; then
        echo "Please provide a name for the virtual environment."
        exit 1
    fi
    python3 -m venv "$1"
    echo "Virtual environment '$1' created."
}

# Function to activate the virtual environment
activate_venv() {
    if [ -z "$1" ]; then
        echo "Please provide the name of the virtual environment to activate."
        exit 1
    fi
    source "$1/bin/activate"
    echo "Activated virtual environment '$1'."
}

# Function to deactivate the virtual environment
deactivate_venv() {
    deactivate
    echo "Deactivated the virtual environment."
}

# Function to freeze installed packages to requirements.txt
freeze_requirements() {
    if [ -f requirements.txt ]; then
        echo "requirements.txt already exists. Overwriting..."
    fi
    pip freeze > requirements.txt
    echo "Generated requirements.txt with installed packages."
}

# Main script logic
case $1 in
    create)
        create_venv "$2"
        ;;
    activate)
        activate_venv "$2"
        ;;
    deactivate)
        deactivate_venv
        ;;
    freeze)
        freeze_requirements
        ;;
    *)
        echo "Usage: $0 {create|activate|deactivate|freeze} [env_name]"
        exit 1
esac


