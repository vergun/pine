/**
 * Article
 *
 * @module      :: Model
 * @description :: A short summary of how this model works and what it represents.
 *
 */

// Utility module for strings
var path = require('path'), slang = require('slang');

module.exports = {
  
  // Waterline will map out both adapters
  // methods so they are both mixed in
  adapter: ['mongo', 'gitHub'],
  
  schema: true,
  
  autoCreatedAt: false,
  autoUpdatedAt: false,

  attributes: {
    
    file: {
      type: 'string',
      required: true
    },
  	
  	slug: {
  	  type: 'string',
      required: true,
      
      // when unique is set
      // an index is automatically
      // generated
      unique: true,
      
  	},
    
    toJSON: function() {
      var obj = this.toObject();
      delete obj._csrf;
      return obj;
    }
    
  },
  
  beforeValidation: function(values, next) {
    
    if (typeof values.file !== 'undefined') { 
      
      // When multiple slashes are found, 
      // they're replaced by a single one
      values.file = path
                    .normalize(values.file);
                         
      // Return the last part of the path
      // as the candidate for the slug
      values.slug = path
                    .dirname(values.file)
                    .split(path.sep).slice(-1)[0];               
      
      // Prepare the string 
      // to be dasherized
      var re = /[^0-9_]/gi;
      values.slug = values.slug
                    .match(re)
                    .join('');
                                
      // When the string is dasherized
      // Its camelCase is converted to dashes
      // and the string is lowercased
      values.slug = slang.dasherize(values.slug);      
        
    }
    
    next()
  },
  
}
