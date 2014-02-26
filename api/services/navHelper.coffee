#
# * Assist with layout navigation bar
# 

exports.getController = (req, res) ->
  req.target.controller

exports.getAction = (req, res) ->
  req.target.action