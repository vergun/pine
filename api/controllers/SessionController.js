/**
 * SessionController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */


var bcrypt = require('bcrypt')

module.exports = {
  
  // new session view: '/sessions/new'
  // named with quotes to avoid conflict
  // with javascript "new" keyword
  'new' : function(req, res) {
    return res.view()
  },
  
  // create a new session 
  // from POST requests (viewless)
  create: function(req, res, next) {
    
    
    // Redirect to main/index if no email address or password in request
    if (!req.param('email') || !req.param('password')) {
      req.session.flash = { err: 'Email address and/or password missing.'}
      return res.redirect('/')
    }
    
    User.findOneByEmail(req.param('email'), function foundAUser (err, user) {
      // There was an error in user lookup
      if (err) return next(err);
      // No user was found
      if (!user) {
        req.session.flash = {err: 'No user with such e-mail address found.'}
        return res.redirect('/');
      }
      
      // Compare user password to password hash
      bcrypt.compare(req.param('password'), user.encryptedPassword, function(err, ok) {
        // There was an error making a comparison
        if (err) return next(err);
        
        // Password doesn't match
        if (!ok) {
          req.session.flash = { err: 'Password is incorrect'}
          return res.redirect('/')
        }
                
        // Email/password look good, proceed
        req.session.authenticated = true;
        req.session.User = user;
                
        // Admins direct to manage users
        if (req.session.User.admin) {
          res.redirect('/user');
          return;
        }
        
        // Everyone else directs to root
        res.redirect('/');
      });
      
    });
    
  },
  
  
  
  // destroy an existing session
  // from DELETE requests (viewless)
  destroy: function(req, res, next) {
    
    //logout the user
    req.session.destroy();
    
    //redirect to controller
    return res.redirect('/')
    
  }

};
