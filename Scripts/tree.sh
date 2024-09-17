# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    tree.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <2024_alex.sanchez@iticbcn.cat    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/16 20:35:10 by alexsanc          #+#    #+#              #
#    Updated: 2024/09/17 07:59:52 by alexsanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

shopt -s nullglob
dir_count=0
file_count=0

traverse() {
  dir_count=$(($dir_count + 1))
  local directory=$1
  local prefix=$2

  local children=("$directory"/*)
  local child_count=${#children[@]}

  for idx in "${!children[@]}"; do 
    local child=${children[$idx]}

    local child_prefix="│   "
    local pointer="├── "

    if [ $idx -eq $((child_count - 1)) ]; then
      pointer="└── "
      child_prefix="    "
    fi

    echo "${prefix}${pointer}${child##*/}"
    [ -d "$child" ] &&
      traverse "$child" "${prefix}$child_prefix" ||
      file_count=$((file_count + 1))
  done
}

root="."
[ "$#" -ne 0 ] && root="$1"
echo $root

traverse $root ""
echo
echo "$(($dir_count - 1)) directories, $file_count files"
shopt -u nullglob
