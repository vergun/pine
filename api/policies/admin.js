/*
 * Allow admins and deny non admins
 */

module.exports = function(req, res, next) {
  
  // User is an admin
  if (req.session.User && req.session.User.admin) {
    return next();
  }
  
  //User is not an admin
  else {
    
    // Create error for unauthorized user
    var adminRequired = [{name: 'adminRequired', message: "You must be logged in to access this area."}]
   
    req.session.flash = {
      error: adminRequired
    }  
    
    // Proceed to controller
    res.redirect('/article/index');
    return;
  }  
}
