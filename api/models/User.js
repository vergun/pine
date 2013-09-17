/**
 * User
 *
 * @module      :: Model
 * @description :: A short summary of how this model works and what it represents.
 *
 */

module.exports = {
  
  adapter: 'mongo',
  
  schema: true,

  attributes: {
  	
    name: 'string',
    
    admin: {
      type: 'boolean',
      defaultsTo: false
    },
    
    email: {
      type: 'string',
      required: true,
      email: true
    },
    
    password: {
      type: 'string'
    },
    
    encryptedPassword: {
      type: 'string'
    },
    
    // Expand toJSON method to
    // not return certain parameters
    // in HTTP response or API requests
    toJSON: function() {
      var obj = this.toObject();
      delete obj.password;
      delete obj.confirmation;
      delete obj.encryptedPassword;
      delete obj._csrf;
      return obj;
    }
    
  },
  
  // form returns admin as on/unchecked
  // convert this value to true/false
  beforeValidation: function(values, next) {
    
    if (typeof values.admin !== 'undefined') {
      if (values.admin === 'unchecked') {
        values.admin = false;
      } else if (values.admin[1] === 'on') {
        values.admin = true;
      }
    }
    next()
  },
  
  // Before a user is created run some validation
  // on password and password confirmation being the same
  beforeCreate: function (values, next) {
    
    // Check that password is present and password and confirmation equal
    // one another
    if (!values.password || values.password != values.confirmation) {
      return next({ err: "Password doesn't match password confirmation."});
    }
    
    // Hash the provided password with bcrypt, 10 represents the number of
    // rounds to process the data
    require('bcrypt').hash(values.password, 10, function passwordEncrypted(err, encryptedPassword) {
      
      // if the hash can't be created generate an error
      if (err) return next(err);
      
      // set the encryptedPassword to the returned bcrypt hash
      values.encryptedPassword = encryptedPassword;
      
      // move on to create the user
      next();
      
    })
  }

};
