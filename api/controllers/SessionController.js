/**
 * SessionController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */


var bcrypt = require('bcrypt')

module.exports = {
  
  // new session view: '/sessions/new'
  'new' : function(req, res) {
    res.view('session/new')
  },
  
  // create a new session 
  // from POST requests (viewless)
  create: function(req, res, next) {
    
    
    
  },
  
  // destroy an existing session
  // from DELETE requests (viewless)
  destroy: function(req, res, next) {
    
    //logout the user
    req.session.destroy();
    
    //redirect to controller
    return res.redirect('/main/index')
    
  }

};
