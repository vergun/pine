Pine
============

Create, read, edit Pine_Needles Articles

After `git clone`, run:

    npm install

Once packages are installed, you need to copy `/config/application.yml.bak` to `/config/application.yml` and  `/config/database.yml.bak` to `/config/database.yml`.


Then, mount the Pine_Needles submodule.

    git submodule add git@github.com:vergun/Pine_Needles.git
    git submodule init
    git submodule update


Follow the instructions in the submodule's readme

    https://github.com/vergun/Pine_Needles


Make sure your Mongodb instance is running (in console):

    mongod

Lift your server and populate your user database by navigating your url path to: 

    http://localhost:1337/user/populate

You can navigate to the root path and use the app:

    http://localhost:1337    

Default user credentials are:

    admin user:    "admin@test.com"    // "password"
    nonadmin user: "nonadmin@test.com" // "password"

A note on tests:

Unit tests
 
Unit tests can be run from the root directory with:

    npm test

Integration tests use functions from the development version of CasperJS. To install with homebrew:

    brew install casperjs --devel

TODOs:

* improve CRUD operations with git hooks
* move population tasks to boostrap.js
* if git hooks fail display a message to the user
* add socket support to flash messages because of ajax requests
* sockets are broadcasting to all clients, only broadcast to actor
* <CR> tags removal

Server Setup Instructions
==========================

1 Made project folders
mkdir ebs_volume
cd ebs_volume
mkdir shared (stores all shared content across builds)
mkdir releases (stores previous builds)

2 Generated an ssh key for the user, and add it to deploy keys on github
ssh-keygen
copy ~/.ssh/id_rsa.pub contents to github.com/settings/ssh, "Add SSH Key" on pine and pine_needles repos

3 cloned the project into releases/20132411114612
git clone git@github.com:vergun/pine.git ~/ebs_volume/releases/20132411114612

4 Symlinked node_modules and log folders
ln -s ~/ebs_volume/releases/20132411114612 ~/ebs_volume/current
ln -s ~/ebs_volume/shared/node_modules ~/ebs_volume/releases/20132411114612/node_modules
ln -s ~/ebs_volume/shared/log ~/ebs_volume/releases/20132411114612/log

5 Set up yml files
mkdir shared/config
cp releases/20132411114612/config/application.yml.bak shared/config/application.yml
cp releases/20132411114612/config/database.yml.bak shared/config/database.yml
ln -s ~/ebs_volume/shared/config/application.yml ~/ebs_volume/releases/20132411114612/config/application.yml
ln -s ~/ebs_volume/shared/config/database.yml ~/ebs_volume/releases/20132411114612/config/database.yml

6 Enter the correct info into the yml files
vi shared/config/application.yml
vi shared/config/database.yml

7 removed development and test credentials from yml files
vi shared/config/application.yml
vi shared/config/database.yml

8 npm installed
cd current
npm install --production

9 Added the git submodule
git clone git@github.com:vergun/Pine_Needles.git ~/ebs_volume/shared/submodules/Pine_Needles
ln -s ~/ebs_volume/shared/submodules/Pine_Needles ~/ebs_volume/releases/20132411114612/Pine_Needles
git submodule add ~/ebs_volume/shared/submodules/Pine_Needles
git submodule init
git submodule update

10 Build the wintersmith project
cd ~/current/Pine_Needles
wintersmith build

10 Set up the pids
mkdir shared/pids
vi ~/ebs_volume/shared/pids/pine.pid
enter 9170 then save the file

11 Installed pm2 and grunt
cd ~/ebs_volume/shared/node_modules
npm install -g pm2 --python python2
npm install -g grunt

12 Wrote the server scripts
vi ~/ebs_volume/restart_server.sh

13 Setup the Database
vi ~/ebs_volume/shared/config/database.yml

14 Add the environment variable to bashrc
vi ~/.bashrc
export ENV=production

15 Run the server
./~ebs_volume/restart_server.sh

A other improvements
• put app server behind load balancer, use cloudwatch to ping port 6000 
• instead of having db and app on the same instance, split the db and app to separate ec2 instances for fault tolerance
• set up the db drive on a 4 volume raid10 configuration for fault tolerance
• set the mongod log path to shared/log/mongodb.log
• if using nginx or apache set access and error logs to shared/log/access.log and shared/log/error.log for port 6000 traffic
• Move the application off port 80

B Sequence After each deploy
ln -s ~/ebs_volume/releases/20132411114612 ~/ebs_volume/current
ln -s ~/ebs_volume/shared/node_modules ~/ebs_volume/releases/20132411114612/node_modules
ln -s ~/ebs_volume/shared/log ~/ebs_volume/releases/20132411114612/log
cp releases/20132411114612/config/application.yml.bak shared/config/application.yml
cp releases/20132411114612/config/database.yml.bak shared/config/database.yml
ln -s ~/ebs_volume/shared/config/application.yml ~/ebs_volume/releases/20132411114612/config/application.yml
ln -s ~/ebs_volume/shared/config/database.yml ~/ebs_volume/releases/20132411114612/config/database.yml
git submodule add ~/ebs_volume/shared/submodules/Pine_Needles
git submodule init
git submodule update


C Todo
Improve restart_server script to accept command line arguments
