# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    autogit.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <2024_alex.sanchez@iticbcn.cat    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/16 20:34:51 by alexsanc          #+#    #+#              #
#    Updated: 2024/09/17 08:00:01 by alexsanc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

echo "\033[31mLoading Files"
sleep .5
echo "."
sleep .5
echo "."
sleep .5
echo "."
echo "\033[31mFiles Loaded. Adding and Commiting."
git add *
sleep 1
git commit -m "This is an automatic message from AutoGit. This commit was submitted automatically"
sleep 1
git push origin master
