/*---------------------------------------------------------------
  :: sails-github
  -> adapter
---------------------------------------------------------------*/

// Module dependencies
var git = require('gift')

adapter = {
  
  find: function() {},
  findOne: function() {},
  create: function() {},
  update: function() {}
  
}

_.bindAll(adapter, 'find');
module.exports = adapter;