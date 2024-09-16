# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    namegen.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <alexsanc@iticbcn.cat>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/16 20:34:59 by alexsanc          #+#    #+#              #
#    Updated: 2024/09/16 20:35:01 by alexsanc         ###   ########.fr        #
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

# Define the new filename based on the subject and date.
newname=""
case $subject in
    1)
        newname="FM_Sost_$date"
        ;;
    2)
        newname="TUT_$date"
        ;;
    3)
        newname="GBD_$date"
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

# The script must now ask for the syllabus that the file is related to. 
echo "Please, enter the syllabus that the file is related to (avoid special characters):"
read syllabus

# Check for invalid characters in the syllabus
if [[ "$syllabus" =~ [^a-zA-Z0-9_] ]]; then
    echo "Error: Syllabus contains invalid characters. Only alphanumeric characters are allowed."
    exit 1
fi

# Create the final filename including the extension if it exists.
if [ -n "$extension" ]; then
    final_name="$newname"_"$syllabus.$extension"
else
    final_name="$newname"_"$syllabus"
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