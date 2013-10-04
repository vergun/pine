###
SessionController

@module    	  :: Controller
@description	:: Contains logic for handling requests.
###

bcrypt = require("bcrypt")
module.exports =
  
  'new': (req, res) ->
    res.view()

  create: (req, res, next) ->  
    if not req.param("email") or not req.param("password")
      emailOrPasswordMissing = [
        name: "emailOrPasswordMissing"
        message: "Email address and/or password missing."
      ]
      
      req.session.flash = error: emailOrPasswordMissing
      return res.redirect("/")
      
    User.findOneByEmail req.param("email"), foundAUser = (err, user) ->      
      return next(err)  if err
      unless user
        noUserFound = [
          name: "noUserFound"
          message: "No user with such e-mail address found."
        ]
        req.session.flash = error: noUserFound
        return res.redirect("/")
      bcrypt.compare req.param("password"), user.encryptedPassword, (err, ok) ->
        return next(err)  if err
        unless ok
          
          passwordIncorrect = [
            name: "passwordIncorrect"
            message: "Password is incorrect."
          ]
          
          req.session.flash = error: passwordIncorrect
          
          return res.redirect("/")

        req.session.authenticated = true
        req.session.User = user
        
        if req.session.User.admin
          res.redirect "/user"
          return
        
        res.redirect "/"

  destroy: (req, res, next) ->
    req.session.destroy()
    res.redirect "/"