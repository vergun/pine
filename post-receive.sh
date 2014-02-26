#!/bin/sh
cd ~/Documents/Apps/pine/pineneedles
git checkout
git pull https://github.com/sugarcrm/pineneedles development --rebase
git add .
git add -u .
git commit -m "New article"
git push origin development