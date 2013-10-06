###
UserController

@module    	:: Controller
@description	:: Contains logic for handling requests.
###

fh = require('../services/flashHelper')

module.exports =

  'new': (req, res) ->
    res.view {}

  create: (req, res, next) ->
    User.create req.params.all(), userCreated = (err, user) ->
      if err
        req.session.flash = error: err
        return res.redirect("/user/new")
      res.redirect "/user/show/" + user.id

  show: (req, res, next) ->
    User.findOne req.param("id"), userFound = (err, founduser) ->
      return next(err)  if err
      unless founduser
        fh.update req, "error", "user", "could not be found."
        return next()
      res.view founduser: founduser

  index: (req, res, next) ->
    return res.redirect("/user")  if req.param("id")
    User.find foundUsers = (err, users) ->
      return next(err)  if err
      res.view users: users

  edit: (req, res, next) ->
    User.findOne req.param("id"), foundUser = (err, founduser) ->
      return next(err)  if err
      unless founduser
        fh.update req, "error", "user", "doesn\'t exist."
        return next()
      res.view founduser: founduser

  update: (req, res, next) ->
    User.update req.param("id"), req.params.all(), userUpdated = (err) ->
      if err
        req.session.flash = error: err
        res.redirect "/user/edit" + req.param("id")
    fh.update req, "success", "user", "was successfully updated."
    res.redirect "/user/show/" + req.param("id")
    
  populate: (req, res, next) ->
    
    users = []
    
    admin =
      name: "Admin User"
      email: "admin@test.com"
      password: "password"
      confirmation: "password"
      admin: [
        "checked"
        "on"
      ]
    
    nonadmin =
      name: "Nonadmin User"
      email: "nonadmin@test.com"
      password: "password"
      confirmation: "password"
      
    _.each [admin, nonadmin], (user)  ->
      User.findOrCreate email: user.email, user, userCreated = (err, user) ->        
        user["_password"] = "password"
        
        users.push user
        if users.length is 2
          res.send ok: users

  destroy: (req, res, next) ->
    User.findOne req.param("id"), foundUser = (err, user) ->
      return next(err)  if err
      unless user
        fh.update req, "error", "user", "doesn\'t exist"
        return next()
      User.destroy req.param("id"), destroyUser = (err) ->
        next err  if err
        if user.id is req.session.User.id
          req.session.destroy()
          res.redirect "/"
        else
          fh.update req, "success", "user", "was destroyed."
          res.redirect "/user"
