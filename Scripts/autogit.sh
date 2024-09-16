# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    autogit.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alexsanc <alexsanc@iticbcn.cat>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/16 20:34:51 by alexsanc          #+#    #+#              #
#    Updated: 2024/09/16 20:34:52 by alexsanc         ###   ########.fr        #
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
