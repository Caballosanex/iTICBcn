#!/usr/bin/env bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    namegen.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <2024_alex.sanchez@iticbcn.cat    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/18 13:53:41 by alexsanc          #+#    #+#              #
#    Updated: 2024/09/19 11:15:15 by alexsanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# This script generates a new name for an input file based on the iTIC file naming structure.

# Check if the route is passed as a command-line argument
if [ $# -eq 1 ]; then
  route=$1
else
  # If no argument is passed, ask for the file route
  echo "Please, enter the full path of the file you want to rename:"
  read -r route
fi

# Debug: print the file route
echo "Route provided: $route"

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

# Debug: print file details
echo "File name: $name"
echo "File extension: $extension"

# The script must now prompt the user to choose the subject related to the file.
while true; do
    echo "Please, choose the subject that the file is related to:"
    echo "1. FM_Sost"
    echo "2. TUT"
    echo "3. GBD"
    echo "4. ISO"
    echo "5. PAX"
    echo "6. LMSGI"
    read -r subject

    if [[ "$subject" =~ ^[1-6]$ ]]; then
        break
    else
        echo "Invalid selection. Please enter a number between 1 and 6."
    fi
done

# Define the new filename based on the subject, adding special behavior for GBD.
newname=""
case $subject in
    1|2|4|5|6)
        # Ask for RA (Resultat Avaluació)
        while true; do
            echo "Please enter the Resultat Avaluació number (e.g., 1 for RA1, 2 for RA2):"
            read -r RA

            if [[ "$RA" =~ ^[1-9][0-9]*$ ]]; then
                RA="RA$RA"
                break
            else
                echo "Invalid input. Please enter a valid number for RA."
            fi
        done

        # Ask for the Activity (AC) number
        while true; do
            echo "Please enter the Activity number (e.g., 1 for AC01, 2 for AC02):"
            read -r ac

            if [[ "$ac" =~ ^[1-9][0-9]*$ ]]; then
                ac=$(printf "AC%02d" "$ac")
                break
            else
                echo "Invalid input. Please enter a valid number for Activity."
            fi
        done

        # Ask for the last name and first name
        echo "Please enter your last name:"
        read -r lastname

        echo "Please enter your first name:"
        read -r firstname

        # Check for invalid characters in the last name and first name
        if [[ "$lastname" =~ [^a-zA-Z] || "$firstname" =~ [^a-zA-Z] ]]; then
            echo "Error: Names contain invalid characters. Only alphabetic characters are allowed."
            exit 1
        fi

        # Define subject names
        case $subject in
            1)
                subject_name="MFM_Sost"
                ;;
            2)
                subject_name="MTUT"
                ;;
            4)
                subject_name="MISO"
                ;;
            5)
                subject_name="MPAX"
                ;;
            6)
                subject_name="MLMSGI"
                ;;
        esac

        # Create the new name based on the subject format
        newname="${subject_name}_${RA}_${ac}_${lastname}_${firstname}"
        ;;
    3)
        # Special handling for GBD
        while true; do
            echo "Please enter the Resultat Avaluació number (e.g., 1 for RA1, 2 for RA2):"
            read -r RA

            if [[ "$RA" =~ ^[1-9][0-9]*$ ]]; then
                RA="RA$RA"
                break
            else
                echo "Invalid input. Please enter a valid number for RA."
            fi
        done

        # Ask for the Activity (AC) number
        while true; do
            echo "Please enter the Activity number (e.g., 1 for AC01, 2 for AC02):"
            read -r ac

            if [[ "$ac" =~ ^[1-9][0-9]*$ ]]; then
                ac=$(printf "AC%02d" "$ac")
                break
            else
                echo "Invalid input. Please enter a valid number for Activity."
            fi
        done

        # Ask for the last name and first name
        echo "Please enter your last name:"
        read -r lastname

        echo "Please enter your first name:"
        read -r firstname

        # Check for invalid characters in the last name and first name
        if [[ "$lastname" =~ [^a-zA-Z] || "$firstname" =~ [^a-zA-Z] ]]; then
            echo "Error: Names contain invalid characters. Only alphabetic characters are allowed."
            exit 1
        fi

        # Create the new name based on the GBD/ASGBD format
        newname="MGBD_${RA}_${ac}_${lastname}_${firstname}"
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
read -r confirmation
if [[ "$confirmation" != "y" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Check if a file with the same name already exists
target_path="$(dirname "$route")/$final_name"
echo "Target path: $target_path"

if [ -f "$target_path" ]; then
    echo "Warning: A file named $final_name already exists."
    echo "Do you want to overwrite it? (y/n)"
    read -r overwrite
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