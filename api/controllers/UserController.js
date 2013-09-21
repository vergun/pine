/**
 * UserController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

module.exports = {
  
  // Show the new user view ('/user/new')
  // named with quotes to avoid conflict
  // with javascript "new" keyword
  'new': function(req, res) {
    return res.view({});
  },
  
  // Create a new user (posted params)
  create: function(req, res, next) {
    // Attempt to create a user with all request parameters
    User.create(req.params.all(), function userCreated (err, user) {      
      // Return error and redirect if an error
      if (err) {
        req.session.flash = { err: err }
        return res.redirect('/user/new');
      }
      
      // Redirect to view
      res.redirect('/user/show/' + user.id);
    });
  },
  
  // Show the user ('/user/show/:id')
  show: function(req, res, next) {
        
    //Attempt user lookup on :id param
    User.findOne(req.param('id'), function userFound (err, founduser) {
      
      // Error: adapter lookup issue
      if (err) return next(err);
      
      // Error: user couldn't be found
      if (!founduser) {
        
        var noUserFound = [{name: 'noUserFound', message: "User could not be found."}]
 
        req.session.flash = {
          err: noUserFound
        }  
        
        return next();
      }
      
      // User found, proceed to view
      res.view({
        founduser: founduser
      })

    })
    
  },
  
  // User list view ('/user')
  // Only available to administrators
  index: function(req, res, next) { 
        
    // Redirect to index view if an id is supplied
    if (req.param('id')) {
      return res.redirect('/user')
    }
    
    // Get an array of users in the users table
    User.find(function foundUsers(err, users) {
      // Error in user lookup
      if (err) return next(err);
      
      // Else render the view
      res.view({ 
        users: users
      });
      
    })
    
  },
  
  // User Edit view ('/user/edit/:id')
  edit: function(req, res, next) {
        
    // User lookup
    User.findOne(req.param('id'), function foundUser(err, founduser) {
      
      // Error in user lookup
      if (err) return next(err);
      
      // User with :id param not found
      if (!founduser) {
        
        var userNotExist = [{name: 'userNotExist', message: "USer doesn\'t exist."}]
 
        req.session.flash = {
          err: userNotExist
        }  
        
        return next();
        
      }
      
      // User found, render edit view with user object
      return res.view({
        founduser: founduser
      });
    });
    
  },
  
  // Action to process user update PUT requests 
  // ('/user/update/:id')
  update: function(req, res, next) {
    
    // Attempt to update the user :id with all after .toJSON() params
    // .toJSON is called in api/models/user before the object is persisted
    User.update(req.param('id'), req.params.all(), function userUpdated(err) {
      
      // Error in user update
      // Show /user/edit view again
      if (err) {
        req.session.flash = {err: err}
        return res.redirect('/user/edit' + req.param('id'));
      }
      
      
    })
    // User was updated successfully
    // Proceed to /user/show view
    var userUpdated = [{name: 'userUpdated', message: "User was successfully updated."}]
    
    req.session.flash = {
      info: userUpdated
    }
    return res.redirect('/user/show/' + req.param('id'));
  },
  
  // Action to process user DELETE requests
  // ('/user/destroy/:id')
  destroy: function(req, res, next) {
    // user lookup
    User.findOne(req.param('id'), function foundUser(err, user) {
      // Error in user lookup
      if (err) return next(err);
      
      // User with :id param not found
      if (!user) return next({err: 'User doesn\'t exist.'});
      
      // User found, destroy the user object
      User.destroy(req.param('id'), function destroyUser(err) {
        
        // There was an error and user object wasn't destroyed
        if (err) return next(err);
        
      })
      
      // No error, user object was destroyed
      var userDestroyed = [{name: 'userDestroyed', message: "User was destroye."}]
    
      req.session.flash = {
        info: userDestroyed
      }
      
      return res.redirect('/user')

    })
  }
  

};
