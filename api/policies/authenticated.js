/**
* Test whether users are authenticated
*/
module.exports = function (req,res,ok) {
	
	// User is allowed, proceed to controller
	if (req.session.authenticated) {
		return ok();
	} 
  // User must be authenticated
  // to access this resource
   else {
     
     // Create error for unauthorized user
    var loginRequired = "You must be signed in to access this area."
    req.session.flash = { err: loginRequired }
    
    // Redirect user to main path
    return res.redirect('/main/index')
	}
};