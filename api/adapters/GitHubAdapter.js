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

    save: function(collectionName, file, content, res) {

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
      res.send({ok: {message: "File written."} } );
      
        // run post-receive.sh from bash
        function afterSave() {
          var spawn = require('child_process').spawn;
          var postReceive = spawn('sh', [ 'post-receive.sh' ], {
            cwd: process.cwd(),
            env:_.extend(process.env, { PATH: process.env.PATH + ':/usr/local/bin' })
          }); 
        }

      }

  }

  return adapter;

})(); 

// _.bindAll(adapter, 'find', 'findOne', 'create', 'update', 'save', 'afterSave', 'teardown');
