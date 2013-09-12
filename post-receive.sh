#!/bin/sh
cd ~/Documents/Apps/pine/Pine_Needles
git checkout
git pull https://github.com/vergun/Pine_Needles development --rebase
git add .
git add -u .
git commit -m "New article"
git push origin development