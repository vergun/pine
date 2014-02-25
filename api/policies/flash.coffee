#
# * Handle flash messages between controllers and views
# * Flash messages are taken from req and moved to res
# 

module.exports = (req, res, next) ->
  res.locals.flash = {}
  
  unless req.session.flash
    return next() 
    
  res.locals.flash = _.clone req.session.flash
  req.session.flash = {}
  
  next()