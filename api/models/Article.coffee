###
Article

@module      :: Model
@description :: A short summary of how this model works and what it represents.
###

path = require("path")
slang = require("slang")
module.exports =
  
  adapter: [
    "mongo"
    "gitHub"
  ]
  schema: true
  autoCreatedAt: false
  autoUpdatedAt: false
  attributes:
    file:
      type: "string"
      required: true

    slug:
      type: "string"
      required: true
      unique: true

    toJSON: ->
      obj = @toObject()
      delete obj._csrf
      obj

  beforeValidation: (values, next) ->
    if typeof values.file isnt "undefined"
      values.file = appConfig.submodulePath + path.normalize(values.file)
      values.slug = path.dirname(values.file).split(path.sep).slice(-1)[0]
      re = /[^0-9_]/g
      values.slug = values.slug.match(re).join("")
      values.slug = slang.dasherize(values.slug)
    next()