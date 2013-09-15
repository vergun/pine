###
 User ::
   GET /user
   GET /user/edit/:id
   GET /user/show/:id
   POST /user/create
   POST /user/update/:id
   POST /user/destroy/:id
   ###

# Configuration options
config =
  port: '1337'
  url: 'http://localhost'
  title: 'Pine'
  userId: ''

casper = require('casper').create()

casper.start "#{config.url}:#{config.port}" + "/user/new", ->
  casper.test.info "GET /user/new -> POST /user/create"
  @fill "form[action='/user/create']",  
    name: "John Doe" 
    title: "Editor"
    email: "test@test.com"
    password: "password"
    confirmation: "password"
  , false
  
casper.then ->
  @test.assertField("name", "John Doe")
  @test.assertField("title", "Editor")
  @test.assertField("email", "test@test.com")
  @test.assertField("password", "password")
  @test.assertField("confirmation", "password")
  
casper.then ->
  @click('button[type=submit]')
  @waitForText("John Doe")
  
casper.then ->
  casper.test.info "GET /user/show/:id -> POST /user/update/:id"
  url = @getCurrentUrl()
  index = url.lastIndexOf "/"
  userId = url.substr(index)[1..-1]
  config.userId = userId
  
  # This regex compares against a 24 hex character string 
  re = new RegExp "^[0-9a-fA-F]{24}$"
  @test.assertMatch userId, re, 'Testing if user _id is valid'
  @waitForText("Edit")
  
casper.thenClick "#edit-user", ->
  url = @getCurrentUrl()
  @test.assertEquals "#{config.url}:#{config.port}" + "/user/edit/#{config.userId}", url

casper.then ->
  @fill "form[action='/user/update/#{config.userId}']", 
    name: "Jane Doe"
    email: "janedoe@test.com"
  , false
  
casper.then ->
  @test.assertField("name", "Jane Doe")
  @test.assertField("email", "janedoe@test.com")
  
casper.then ->
  @click('button[type=submit]')
  
casper.then ->
  @test.assertSelectorHasText('h2', "Jane Doe")
  
casper.thenOpen "#{config.url}:#{config.port}" + "/user", ->
  @test.info "GET /user -> POST user/destroy/:id"
  @test.assertSelectorHasText('h3', "User Management")
  
casper.then ->
  selector = "form[action='/user/destroy/#{config.userId}'] input[type='submit']"
  @test.assertExists selector
  @click selector
  
casper.then ->
  selector = "form[action='/user/destroy/#{config.userId}'] input[type='submit']"
  @test.assertDoesntExist selector

casper.run ->
  @echo "Done!"
  @exit()