#!/bin/sh
cd ~/Documents/Apps/pine/Pine_Needles
git checkout
git pull https://github.com/vergun/Pine_Needles development --rebase
git push origin development