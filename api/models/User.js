/**
 * User
 *
 * @module      :: Model
 * @description :: A short summary of how this model works and what it represents.
 *
 */

module.exports = {
  
  schema: true,

  attributes: {
  	
    name: 'string',
    
    is_admin: {
      type: 'boolean',
      default: false
    },
    
    email: {
      type: 'string',
      required: true,
      email: true
    },
    
    password: {
      type: 'string'
    },
    
    encrypted_password: {
      type: 'string'
    }
    
  }

};
