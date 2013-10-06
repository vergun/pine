###
UserController

@module    	:: Controller
@description	:: Contains logic for handling requests.
###

flash           = require '../services/flashHelper'
PopulateHelper  = require '../services/populateHelper'

UserController =

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
        flash.msg req, "error", "user", "could not be found.", ->
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
        flash.msg req, "error", "user", "doesn\'t exist.", ->
          return next()
      res.view founduser: founduser

  update: (req, res, next) ->
    User.update req.param("id"), req.params.all(), userUpdated = (err) ->
      if err
        req.session.flash = error: err
        res.redirect "/user/edit" + req.param("id")
    flash.msg req, "success", "user", "was successfully updated.", ->
      res.redirect "/user/show/" + req.param("id")
  
  destroy: (req, res, next) ->
    User.findOne req.param("id"), foundUser = (err, user) ->
      return next(err)  if err
      unless user
        flash.msg req, "error", "user", "doesn\'t exist", ->
          return next()
      User.destroy req.param("id"), destroyUser = (err) ->
        next err  if err
        if user.id is req.session.User.id
          req.session.destroy()
          res.redirect "/"
        else
          flash.msg req, "success", "user", "was destroyed.", ->
            res.redirect "/user"
  
  populate: (req, res) ->
    PopulateHelper.populateUsers (users) ->
      res.send ok: users
      
module.exports = UserController

