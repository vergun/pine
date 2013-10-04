###
UserController

@module    	:: Controller
@description	:: Contains logic for handling requests.
###
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
        noUserFound = [
          name: "noUserFound"
          message: "User could not be found."
        ]
        req.session.flash = error: noUserFound
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
        userNotExist = [
          name: "userNotExist"
          message: "USer doesn't exist."
        ]
        req.session.flash = error: userNotExist
        return next()
      res.view founduser: founduser

  update: (req, res, next) ->
    User.update req.param("id"), req.params.all(), userUpdated = (err) ->
      if err
        req.session.flash = error: err
        res.redirect "/user/edit" + req.param("id")
    userUpdated = [
      name: "userUpdated"
      message: "User was successfully updated."
    ]
    req.session.flash = info: userUpdated
    res.redirect "/user/show/" + req.param("id")
    
  populate: (req, res, next) ->
    _.extend req.params.all(),
      name: "Test User"
      email: "test@test.com"
      password: "password"
      confirmation: "password"
      admin: [
        "checked"
        "on"
      ]
    
    User.create req.params.all(), userCreated = (err, user) ->
      if err 
        return res.send err
      if user
        user = _.extend user,
                 pass: "password"
        return res.send ok: user
      res.redirect "/"

  destroy: (req, res, next) ->
    User.findOne req.param("id"), foundUser = (err, user) ->
      return next(err)  if err
      unless user
        userDoesntExist = [
          name: "userDoesntExist"
          message: "User doesn't exist."
        ]
        req.session.flash = info: userDoesntExist
        return next()
      User.destroy req.param("id"), destroyUser = (err) ->
        next err  if err
      userDestroyed = [
        name: "userDestroyed"
        message: "User was destroye."
      ]
      req.session.flash = info: userDestroyed
      res.redirect "/user"
