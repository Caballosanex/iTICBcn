#!/bin/bash

# This script inserts a header with a "42" ASCII art at the top of a given file.

# Check if the filename is passed as a command-line argument
if [ -z "$1" ]; then
  echo "Usage: $0 filename"
  exit 1
fi

filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
  echo "Error: File '$filename' does not exist."
  exit 1
fi

# Get current date and time
created_date=$(date +"%Y-%m-%d %H:%M:%S")
updated_date=$(date +"%Y-%m-%d %H:%M:%S")

# Get the username and hostname
username=$(whoami)
hostname=$(hostname)

# Extract the base filename (no directory, just the file)
base_filename=$(basename "$filename")

# Generate the header with a "42" ASCII art in the center
header="/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   $base_filename                                      :+:      :+:    :+:  */
/*                                                    +:+ +:+         +:+     */
/*   By: $username <$username@$hostname>              +#+  +:+       +#+      */
/*                                                +#+#+#+#+#+      +#+        */
/*   Created: $created_date by $username          #+#    #+#      :+:         */
*/							 							 #+4	 :::::::::::  */
/*   Updated: $updated_date by $username			              			  */
/*                                                                            */
/* ************************************************************************** */"

# Insert the header at the top of the file
# Use a temporary file to safely insert the header
{
  echo "$header"
  cat "$filename"
} > temp_file && mv temp_file "$filename"

echo "Header inserted into $filename"

