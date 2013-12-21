###
Article

@module      :: Model
@description :: A short summary of how this model works and what it represents.
###

path = require("path")
module.exports =  
  adapter: [
    "sails-github"
    "sails-wintersmith"
    "sails-s3"
    ]
  attributes:
    toJSON: ->
      obj = @toObject()
      delete obj._csrf
      obj