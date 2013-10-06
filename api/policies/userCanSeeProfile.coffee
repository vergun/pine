#
# * Allow authenticated users to see their 
# * own profiles
# 

module.exports = (req, res, next) ->
  
  sessionUserMatchesId = req.session.User.id is req.param("id")
  isAdmin = req.session.User.admin
  unless sessionUserMatchesId or isAdmin
    noRightsError = [
      name: "noRights"
      message: "You must be an admin."
    ]
    req.session.flash = error: noRightsError
    res.redirect "/session/new"
    return
  next()