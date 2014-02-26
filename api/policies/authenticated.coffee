###
Test whether users are authenticated
###
module.exports = (req, res, next) ->

  if req.session.authenticated
    next()
  else
    loginRequired = [
      name: "loginRequired"
      message: "You must be logged in to access this area."
    ]
    req.session.flash = error: loginRequired
    res.redirect "/article/index"