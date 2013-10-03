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

Lift your server and populate your database by navigating your url path to: 

    http://localhost:1337/article/populate

You can navigate to the root path and use the app:

    http://localhost:1337

TODOs:

* improve CRUD operations with git hooks
* move population tasks to boostrap.js
* add a population task for first user in dev

