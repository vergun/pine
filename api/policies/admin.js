/*
 * Allow admins and deny non admins
 */

module.exports = function(req, res, ok) {
  
  // User is an admin
  if (req.session.User && req.session.User.admin) {
    return next();
  }
  //User is not an admin
  else {
   // Create error for unauthorized user
    var adminRequired = "You must be an admin to access this area."
    req.session.flash = { err: 
       [ { msg: adminRequired } ] 
     }
    
    // Proceed to controller
    res.redirect('/article/index');
    return;
  }  
}
