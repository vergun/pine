exports.getController = function(req, res) {
  return req.target.controller;
}

exports.getAction = function(req, res) {
  return req.target.action;
}

