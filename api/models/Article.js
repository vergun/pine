/**
 * Article
 *
 * @module      :: Model
 * @description :: A short summary of how this model works and what it represents.
 *
 */

module.exports = {
  
  adapter: 'gitHub',
  
  schema: true,

  attributes: {
    
    title: {
      type: 'string'
    },
  	
  	content: {
  	  type: 'string'
  	},
    
    toJSON: function() {
      var obj = this.toObject();
      delete obj._csrf;
      return obj;
    }
    
  }
  
}
