#!/bin/bash
clear

# DETERMINE REPO NAME
repo_name=$(basename "$PWD")

echo ""
echo " REPO name will be set as $repo_name"
echo ""

echo "# $repo_name" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -m master
git remote add origin https://github.com/jaxtechnologies/$repo_name.git
git push -u origin master

exit