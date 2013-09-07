/*---------------------------------------------------------------
  :: sails-github
  -> adapter
---------------------------------------------------------------*/

// Module dependencies

adapter = {
  
  find: function() {},
  findOne: function() {},
  create: function() {},
  update: function() {}
  
}

_.bindAll(adapter, 'find');
module.exports = adapter;