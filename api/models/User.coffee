###
User

@module      :: Model
@description :: A short summary of how this model works and what it represents.
###
module.exports =
  
  adapter: "mongo"
  schema: true
  attributes:
    name: "string"
    admin:
      type: "boolean"
      defaultsTo: false

    email:
      type: "string"
      required: true
      email: true
      unique: true

    encryptedPassword:
      type: "string"

    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.confirmation
      delete obj.createdAt
      delete obj.updatedAt
      delete obj._csrf
      delete obj.encryptedPassword
      obj

  beforeValidation: (values, next) ->
    if typeof values.admin isnt "undefined"
      if values.admin is "unchecked"
        values.admin = false
      else values.admin = true  if values.admin[1] is "on"
    next()

  beforeCreate: (values, next) ->
    if not values.password or values.password isnt values.confirmation
      passwordAndConfirmationNotMatch = [
        name: "passwordAndConfirmationNotMatch"
        message: "Password doesn't match password confirmation."
      ]
      return next(error: passwordAndConfirmationNotMatch)
    require("bcrypt").hash values.password, 10, passwordEncrypted = (err, encryptedPassword) ->
      return next(err)  if err
      values.encryptedPassword = encryptedPassword
      next()
      
  afterCreate: (values, next) ->
    delete values.password
    delete values.confirmation
    delete values.encryptedPassword
    delete values._csrf
    next()
