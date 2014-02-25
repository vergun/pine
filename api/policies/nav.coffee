#
# * Automatically assign the active tab based on req.
# * target params from services/navHelper
# 

navHelper = require("../services/navHelper")

module.exports = (req, res, next) ->

  if req.session.authenticated
    sessionUserMatchesId = req.session.User.id is req.param("id")
    if sessionUserMatchesId
      res.locals.selected = "editProfile"
      return next()
  res.locals.selected = navHelper.getController(req, res)
  next()