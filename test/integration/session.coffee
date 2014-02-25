###
 Session ::
   GET /session/new
   POST /session/create
   DELETE /session/:id
   ###

# Configuration options
config =
  port: '1337'
  url: 'http://localhost'
  title: 'Pine'
  userId: ''

casper = require('casper').create()

casper.start "#{config.url}:#{config.port}" + "/session/new", ->
  casper.test.info "GET /session/new -> POST /session/create"
  @fill "form[action='/session/create']",  
    email: "test@test.com" 
    password: "password"
  , false
  
  casper.then ->
    @test.assertField("email", "test@test.com")
    @test.assertField("password", "password")
    
  casper.then ->
    @click('button[type=submit]')
    @waitForText "You have been successfully logged in."