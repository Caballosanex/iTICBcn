#!/bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    pythonette.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <alexsanc@student.42barcel>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/05/17 17:00:30 by alexsanc          #+#    #+#              #
#    Updated: 2023/05/17 18:07:23 by alexsanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

## This program automates the installation of pycodestyle and the creation of the alias pythonette
## The alias pythonette wil be used to check your PEP8 compliance of your python files.
## It will detect if you already have pycodestyle installed and if you already have the alias pythonette.
## Pycodestyle will be installed through pip to your home directory without sudo rights. Thus you will be able to use it on the 42 computers.

# Define the installation directory for pycodestyle
INSTALL_DIR="$HOME"

# Check if pycodestyle is already installed
if ! command -v pycodestyle >/dev/null 2>&1; then
    # Check if pip or pip3 is available
    if command -v pip >/dev/null 2>&1; then
        PIP_COMMAND="pip"
    elif command -v pip3 >/dev/null 2>&1; then
        PIP_COMMAND="pip3"
    else
        echo "Error: pip and pip3 are not installed." >&2
        exit 1
    fi

    # Install pycodestyle using pip or pip3
    if ! "$PIP_COMMAND" install --user pycodestyle; then
        echo "Error: Failed to install pycodestyle using $PIP_COMMAND." >&2
        exit 1
    fi
fi

# Determine the shell configuration file
if [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
else
    echo "Error: Unable to find .bashrc or .zshrc file." >&2
    exit 1
fi

# Check if the alias pythonette is already created
if ! grep -q "alias pythonette" "$SHELL_CONFIG_FILE"; then
    # Add the alias pythonette to the shell config file
    echo "alias pythonette='(python3 -m pycodestyle --show-pep8 --max-line-length=300 \$(find . -name \"*.py\")) || (pip3 install --user pycodestyle && python3 -m pycodestyle --show-pep8 --max-line-length=300 \$(find . -name \"*.py\"))'" >> "$SHELL_CONFIG_FILE"
else
    printf "\033[33m The alias pythonette is already created.\033[0m\n"
fi

# Source the shell config file to apply the changes
if ! source "$SHELL_CONFIG_FILE"; then
    echo "Error: Failed to source $SHELL_CONFIG_FILE." >&2
    exit 1
fi

# Print a message to inform the user that the alias pythonette is now available
echo "The alias pythonette is now available."
printf "\033[33m You may now proceed to restart the shell and use the alias pythonette.\033[0m\n"

# Clean up downloaded files (if any)
if [ -f "$INSTALL_DIR/get-pip.py" ]; then
    rm "$INSTALL_DIR/get-pip.py"
fi

exit 0
