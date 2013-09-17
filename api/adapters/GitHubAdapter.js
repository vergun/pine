/*---------------------------------------------------------------
  :: sails-github
  -> adapter
---------------------------------------------------------------*/

// Module dependencies
var git = require('gift'), fs = require('fs');

module.exports = (function() {
      
  adapter = {
    // no db dependencies
    syncable: false,
  
    //todo move appConfig to adapter defaults
    defaults: {},
    
    registerCollection: function(collectionName, cb) {
      
      // for use in other methods
      var self = this;
      
      return cb();
    },
    
    teardown: function(cb) {
      if(cb) cb();
    },
    
    fetch: function(collectionName, file, next) {
      var file = fs.readFileSync(file);
      next(null, file)  
    },

    save: function(collectionName, file, content, next) {

      // explicitly declare args
      var file = file, content = content;
      // write the file to the filesystem
      fs.writeFile(appConfig.submodulePath + file, content, function(err, data) {
  
        // send proper error response if an error
        if (err) res.send({err: {message: "Couldn't write file."} } );
  
      });

      // otherwise update GitHub
      afterSave();

      // and send ok response
      next.send({ok: {message: "File written."} } );
      
        // run post-receive.sh from bash
        function afterSave() {
          var spawn = require('child_process').spawn;
          var postReceive = spawn('sh', [ 'post-receive.sh' ], {
            cwd: process.cwd(),
            env:_.extend(process.env, { PATH: process.env.PATH + ':/usr/local/bin' })
          }); 
        }

      },
      
      refresh: function(collectionName, file, content, next) {
        // explicitly declare args
        var file = file, content = content;
        // write the file to the filesystem
        fs.writeFile(file, content, function(err, data) {
  
          // send proper error response if an error
          if (err) return res.send({err: {message: "Couldn't write file."} } );
          
          // update GitHub
          afterSave();   
          // proceed to controller
          next(err, {file: file, content: content})          
  
        });     
      
        // run post-receive.sh from bash
        function afterSave() {
          var spawn = require('child_process').spawn;
          var postReceive = spawn('sh', [ 'post-receive.sh' ], {
            cwd: process.cwd(),
            env:_.extend(process.env, { PATH: process.env.PATH + ':/usr/local/bin' })
          }); 
        }
          
      },
      
      list: function(collectionName, path, next) {
        
        // traverse the submodule collection tree
        // and extract all files into an array
        walk(path, function (err, files) {
          if (err) next.send(err)
          if (files) return next.view({ files: files });
        });

        function walk(dir, done) {
          var results = [];
          fs.readdir(dir, function(err, list) {
            if (err) return done(err);
            var i = 0;
            (function next() {
              var file = list[i++];
              if (!file) return done(null, results);
              file = dir + '/' + file;
              fs.stat(file, function(err, stat) {
                if (stat && stat.isDirectory()) {
                  walk(file, function(err, res) {
                    results = results.concat(res);
                    next();
                  });
                } else {
                  // regular expression for markdown file extension
                  var re = /\.[md]+$/i;
                  if (re.test(file)) results.push(file);
                  next();
                }
              });
            })();
          });
        }
      }
  }

  return adapter;

})(); 

// _.bindAll(adapter, 'find', 'findOne', 'create', 'update', 'save', 'afterSave', 'teardown');
