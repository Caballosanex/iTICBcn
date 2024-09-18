# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    namegen.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <2024_alex.sanchez@iticbcn.cat    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/16 20:34:59 by alexsanc          #+#    #+#              #
#    Updated: 2024/09/18 11:47:59 by alexsanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

# This script generates a new name for an input file based on the iTIC file naming structure.

# Check if the route is passed as a command-line argument
if [ $# -eq 1 ]; then
  route=$1
else
  # If no argument is passed, ask for the file route
  echo "Please, enter the full path of the file you want to rename:"
  read route
fi

# Check if the file exists
if [ ! -f "$route" ]; then
  echo "Error: File does not exist."
  exit 1
fi

# The name of the file is stored in the variable "name" and its extension in "extension".
name=$(basename "$route")

if [[ "$name" == *.* ]]; then
   extension="${name##*.}"
else
   extension=""
fi

# The script must now prompt the user to choose the subject related to the file.
while true; do
    echo "Please, choose the subject that the file is related to:"
    echo "1. FM_Sost"
    echo "2. TUT"
    echo "3. GBD"
    echo "4. ISO"
    echo "5. PAX"
    echo "6. LMSGI"
    read subject

    if [[ "$subject" =~ ^[1-6]$ ]]; then
        break
    else
        echo "Invalid selection. Please enter a number between 1 and 6."
    fi
done

# Get the current date and time and store it in the variable "date".
date=$(date +"%Y%m%d_%H%M%S")

# Define the new filename based on the subject and date, adding special behavior for GBD.
newname=""
case $subject in
    1)
        newname="FM_Sost_$date"
        ;;
    2)
        newname="TUT_$date"
        ;;
    3)
        # Special handling for GBD, ask if it's GBD or ASGBD, and ask for UF and AC
        echo "You have selected GBD. Do you want to use:"
        echo "1. GBD"
        echo "2. ASGBD"
        read module_choice
        if [[ "$module_choice" == "1" ]]; then
            mod="M02"  # GBD
        elif [[ "$module_choice" == "2" ]]; then
            mod="M03"  # ASGBD
        else
            echo "Invalid choice. Exiting."
            exit 1
        fi

        # Ask for UF (Unitat Formativa)
        while true; do
            echo "Please, enter the Unitat Formativa number (e.g., 1 for UF1, 2 for UF2):"
            read uf

            if [[ "$uf" =~ ^[1-9][0-9]*$ ]]; then
                uf="UF$uf"
                break
            else
                echo "Invalid input. Please enter a valid number for UF."
            fi
        done

        # Ask for the Activity (AC) number
        while true; do
            echo "Please, enter the Activity number (e.g., 1 for AC01, 2 for AC02):"
            read ac

            if [[ "$ac" =~ ^[1-9][0-9]*$ ]]; then
                ac=$(printf "AC%02d" "$ac")
                break
            else
                echo "Invalid input. Please enter a valid number for Activity."
            fi
        done

        # Ask for the last name and first name
        echo "Please, enter your last name:"
        read lastname

        echo "Please, enter your first name:"
        read firstname

        # Check for invalid characters in the last name and first name
        if [[ "$lastname" =~ [^a-zA-Z] || "$firstname" =~ [^a-zA-Z] ]]; then
            echo "Error: Names contain invalid characters. Only alphabetic characters are allowed."
            exit 1
        fi

        # Create the new name based on the GBD/ASGBD format
        newname="${mod}_${uf}_${ac}_${lastname}_${firstname}"
        ;;
    4)
        newname="ISO_$date"
        ;;
    5)
        newname="PAX_$date"
        ;;
    6)
        newname="LMSGI_$date"
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac

# Add the extension if it exists
if [ -n "$extension" ]; then
    final_name="$newname.$extension"
else
    final_name="$newname"
fi

# Show new filename and ask for confirmation before proceeding
echo "The file will be renamed to: $final_name"
echo "Do you want to proceed? (y/n)"
read confirmation
if [[ "$confirmation" != "y" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Check if a file with the same name already exists
target_path="$(dirname "$route")/$final_name"
if [ -f "$target_path" ]; then
    echo "Warning: A file named $final_name already exists."
    echo "Do you want to overwrite it? (y/n)"
    read overwrite
    if [[ "$overwrite" != "y" ]]; then
        echo "Operation cancelled."
        exit 1
    fi
fi

# Rename the file and handle errors
if mv "$route" "$target_path"; then
    echo "File renamed successfully to $final_name"
else
    echo "Error: Failed to rename the file."
    exit 1
fi

exit 0
