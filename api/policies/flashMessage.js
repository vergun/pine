/*
 * Handle flash messages between controllers and views
 * Flash messages are taken from req and moved to res
 */

module.exports = function(req, res, next) {

  //reset locals flash nessages
 res.locals.flash = {};
 
 // if no flash messages in req proceed to controller
 if(!req.session.flash) return next();

 // clone req flash messages into res
 // because we'll reset req flash
 res.locals.flash = _.clone(req.session.flash);

 // clear req flash
 req.session.flash = {};

 // proceed to controller
 next();
 
};