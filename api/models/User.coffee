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

    password:
      type: "string"

    encryptedPassword:
      type: "string"

    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.confirmation
      delete obj.encryptedPassword
      delete obj._csrf
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
