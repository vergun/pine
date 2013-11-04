###
Article

@module      :: Model
@description :: A short summary of how this model works and what it represents.
###

path = require("path")
module.exports =  
  adapter: "sails-github"
  attributes:
    toJSON: ->
      obj = @toObject()
      delete obj._csrf
      obj