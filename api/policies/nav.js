/*
 * Automatically assign the active tab based on req.
 * target params from services/navHelper
 */
var navHelper = require('../services/navHelper');

module.exports = function(req, res, next) {
  
  // if the user is editing his/her profile set active tab 
  // to the tab that bears the user's name

	if (req.session.authenticated) {
    
    var sessionUserMatchesId = req.session.User.id === req.param('id');
  
    if (sessionUserMatchesId) {
      res.locals.selected = 'editProfile';
      return next();
    }
		
	} 
  
  //else get the active tab from the req controller
  res.locals.selected = navHelper.getController(req, res);
  
  // proceed to controller
  next();
 
};