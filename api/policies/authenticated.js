/**
* Test whether users are authenticated
*/
module.exports = function (req,res,next) {
	
	// User is allowed, proceed to controller
	if (req.session.authenticated) {
		return next();
	} 
  // User must be authenticated
  // to access this resource
   else {
     
     // Create error for unauthorized user    
    var loginRequired = "You must be an admin to access this area."
    
    req.session.flash = { err: 
       [ { msg: loginRequired } ] 
     }
         
    // Redirect user to main path
    res.redirect('/article/index')
	}
};