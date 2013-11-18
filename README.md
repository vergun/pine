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
* improve WYSIWIG editor to accomodate html AND md

Server Setup Instructions
==========================

Development server: maia.ottomanhipster.com
Production server: pine.ottomanhipster.com

      sudo apt-get install build-essential libssl-dev curl git-core
      cd ~
      git clone git://github.com/creationix/nvm.git ~/.nvm
      echo "\n. ~/.nvm/nvm.sh" >> .bashrc
      source ~/.nvm/nvm.sh
      nvm install v0.10.22
      nvm alias default 0.10.22
      cd /root/.ssh/authorized_keys
      add your /.ssh/id_rsa.pub ssh-key to authorized_keys (vi authorized_keys)
      apt-get install node
      apt-get update --fix-missing
      apt-get install npm
      adduser pine
      adduser maia
      su pine
      mkdir /home/pine/.ssh && cd /home/pine/.ssh
      ssh-keygen
      vi authorized_keys
      add your /.ssh/id_rsa.pub ssh-key to authorized_keys (vi authorized_keys)
      su maia
      mkdir /home/maia/.ssh && cd /home/maia/.ssh
      ssh-keygen
      vi authorized_keys
      add your /.ssh/id_rsa.pub ssh-key to authorized_keys (vi authorized_keys)
      •• Upload key from /home/username/.ssh/id_rsa.pub to github user •• 
      mkdir /ebs_volume
      cd /dev
      mount xvdf /ebs_volume (or whatever is returned by lsblk or df)
      cd /ebs_volume
      sudo su - (or ctrl-c to get back to root user)
      mkdir pine
      mkdir maia
      chgrp pine pine
      chown pine pine
      chown maia maia
      chown maia maia
      visudo(and add the next two lines:)
      pine    ALL=(ALL:ALL) ALL
      maia    ALL=(ALL:ALL) ALL
      su pine
      cd /ebs_volume/pine
      mkdir shared
      mkdir shared/node_modules
      mkdir shared/log
      cd .. && git clone git@github.com:vergun/pine.git
      su maia
      cd /ebs_volume/maia
      mkdir shared
      mkdir shared/node_modules
      mkdir shared/log
      cd .. && git clone git@github.com:vergun/pine.git
      su pine
      cd /ebs_volume
      npm install -g coffee-script
      ln -s /ebs_volume/pine/current/package.json /ebs_volume/pine/shared
      npm install
      ln -s /ebs_volume/pine/shared/node_modules /ebs_volume/pine/current/node_modules
      ln -s /ebs_volume/pine/shared/log /ebs_volume/pine/current/log
      mkdir config && cd config
      cp /ebs_volume/pine/current/config/application.yml.bak /ebs_volume/pine/shared/config/application.yml
      cp /ebs_volume/pine/current/config/database.yml.bak /ebs_volume/pine/shared/config/database.yml
      ln -s /ebs_volume/pine/shared/config/application.yml /ebs_volume/pine/current/config/application.yml
      ln -s /ebs_volume/pine/shared/config/database.yml /ebs_volume/pine/current/config/database.yml
      cd /ebs_volume/pine/current
      git submodule add git@github.com:vergun/Pine_Needles.git
      git submodule init
      git submodule update
      cd /ebs_volume/pine/shared
      mkdir /ebs_volume/pine/shared/pids
      vi /ebs_volume/pine/shared/pids/pine.pid
      enter 777 then save the file
      cd /ebs_volume/pine/shared/node_modules
      npm install forever
      cd /ebs_volume/pine 
      vi restart_server
      Then enter this into the file and save it:

      #!/bin/bash

      echo 'cd /ebs_volume/pine/current; node node_modules/forever/bin/forever stop --pidFile /ebs_volume/pine/shared/pids/pine.pid /ebs_volume/pine/current/app.js; sleep 3; node_modules/forever/bin/forever start /ebs_volume/pine/current/app.js -l /ebs_volume/pine/shared/log/forever.log -o /ebs_volume/pine/shared/log/forever.out.log -e /ebs_volume/pine/shared/log/forever.err.log --pidFile /ebs_volume/pine/shared/pids/pine.pid' | bash -l

      sudo su -
      chmod 700 restart_server
      then chmod 700 the file

      Edit application.yml
      : set production port to 6000
      : set submodule path to 
      Edit database.yml
      : set production db from db server
      General guidance: https://github.com/balderdashy/sails/wiki/deployment

