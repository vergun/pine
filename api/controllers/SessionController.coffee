###
SessionController

@module    	  :: Controller
@description	:: Contains logic for handling requests.
###

bcrypt    = require 'bcrypt'
flash     = require '../services/flashHelper'

module.exports =
  
  'new': (req, res) ->
    res.view()

  create: (req, res, next) ->  
    if not req.param("email") or not req.param("password")
      flash.msg req, "error", "email", "address and/or password missing.", ->
        return res.redirect("/")
      
    User.findOneByEmail req.param("email"), foundAUser = (err, user) ->      
      return next(err)  if err
      unless user
        flash.msg req, "error", "user", "with such e-mail address not found."
        return res.redirect("/")
      bcrypt.compare req.param("password"), user.encryptedPassword, (err, ok) ->
        return next(err)  if err
        unless ok
          flash.msg req, "error", "password", "is incorrect."
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