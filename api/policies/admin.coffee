#
# * Allow admins and deny non admins
# 

module.exports = (req, res, next) ->
  
  if req.session.User and req.session.User.admin
    next()  
  else    
    adminRequired = [
      name: "adminRequired"
      message: "You must be an administrator to access this area."
    ]
    req.session.flash = error: adminRequired    
    res.redirect "/article/index"
    return