#
# * If the user is within the session
# * assigns user to locals so that
# * the authenticated user can always
# * be accessed within a view template
# 

module.exports = (req, res, next) ->
  res.locals.user = req.session.User if req.session.User
  next()