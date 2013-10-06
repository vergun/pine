###
 User ::
   GET /user
   GET /user/edit/:id
   GET /user/show/:id
   POST /user/create
   POST /user/update/:id
   POST /user/destroy/:id
   ###

config =
  port: '1337'
  url: 'http://localhost'
  title: 'Pine'
  userId: ''

casper = require('casper').create()

casper.start "#{config.url}:#{config.port}", ->
  casper.test.comment "Test user flow as administrator"
  @fill "form[action='/session/create']", 
    email: "admin@test.com"
    password: "password"
  , false 

casper.then ->
  @test.assertField("email", "admin@test.com")
  @test.assertField("password", "password")

casper.then ->
  @click "form[action='/session/create'] button[type=submit]"
  @waitForText "User Management"

casper.thenOpen "#{config.url}:#{config.port}" + "/user/new", ->
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
  config.userId = url.substr(index)[1..-1]
  re = new RegExp("^[0-9a-fA-F]{24}$")
  @test.assertMatch config.userId, re, 'user _id is valid'
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
  @test.assertSelectorHasText('h3#user-show-name', "Jane Doe")
  
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
  
casper.thenClick "a[href='/session/destroy']", ->
  @test.comment "Test user flow as authenticated non-administrator"
  url = @getCurrentUrl()
  @test.assertEquals "#{config.url}:#{config.port}/", url

casper.run ->
  @echo "Done!"
  @exit()