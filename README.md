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
* if git hooks fail display a message to the user

Server Setup Instructions
==========================

Development server: maia.ottomanhipster.com
Production server: pine.ottomanhipster.com

    App server
    1 Root EBS Volume
    1 attached EBS Volume for applications

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

    Db server
    1 Root EBS Volume
    4 attached EBS Volumes for DB in RAID10 Configuration

    sudo su -
    cd /root/.ssh
    vi authorized_keys
    add your key to the file
    apt-get install mdadm
    Select "no configuration"
    mdadm --create -l10 -n4 /dev/md0 /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde

    explained (mirroring without paring, block level striping, 2 sets of raid 1):
    n is the number of drives
    /dev/md0 is the created drive
    /dev/xvd* are the names of the drives to form into RAID10
    sudo apt-get install xfsprogs

    mkdir /ebs_volume
    mkfs -t xfs /dev/md0
    mount md0 /ebs_volume

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get update
    sudo apt-get install mongodb-10gen

    adduser mongo
    mkdir /ebs_volume/mongo
    chgrp mongo /ebs_volume/mongo
    chown mongo /ebs_volume/mongo
    mkdir /ebs_volume/shared
    mkdir /ebs_volume/shared/log
    vi /ebs_volume/start_mongo
    Enter this and save the file:

    #!/bin/bash
    mongod --fork --dbpath /ebs_volume/mongo --logpath /ebs_volume/shared/log/mongodb.log

    chown mongo /ebs_volume/start_mongo
    chgrp mongo /ebs_volume/start_mongo
    chmod 755 start_mongo
    ./start_mongo
    mongo
    db.addUser({user: "mongo", pwd: "passwrod", roles: [ "readWrite" ]})
    exit

    netstat -lnptu
    note the port that mongo is running on (should be 27107)
    open up port 27017 and 28107 in security group

    Note the url:
    'mongodb://<yourelasticip>:<port>'
    i.e.:
    'mongodb://107.21.230.121:27017'

    production
    mongodb://mongo:passwrod@54.204.42.127:27017/pine

    stage
    mongodb://mongo:passwrod@54.204.42.127:27017/pine_stage

    On the app server
    cd /home/pine/.ssh
    ssh-keygen
    copy the id_rsa.pub to clipboard, and paste it into authorized_keys on user mongo on the db server
    ... on the db server ...
    cd /home/mongo/.ssh
    vi authorized_keys
