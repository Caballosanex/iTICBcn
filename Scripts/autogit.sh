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
