/*
 * If the user is within the session
 * assigns user to locals so that
 * the authenticated user can always
 * be accessed within a view template
 */

module.exports = function(req, res, next) {
  
  //assign session user to user
  if (req.session.User) {
    res.locals.user = req.session.User
  }
  
  // proceed to controller
  next()
 
};