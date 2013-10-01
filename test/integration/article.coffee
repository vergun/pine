###
 Article ::
   GET /article
   GET /article/edit/:id
   GET /article/show/:id
   ###

# Configuration options
config =
  port: '1337'
  url: 'http://localhost'
  title: 'Pine'
  articleId: ''
  
fs = require 'fs'
casper = require('casper').create()

# todo rewrite walk function for phantom.js fs module, partially functional
# so that the assertElementCount is dynamic not hardcoded
# https://github.com/ariya/phantomjs/wiki/API-Reference-FileSystem
walk = (path, callback) ->
  results = []
  (iterator = (path) ->
    fs.changeWorkingDirectory path
    casper.test.info fs.workingDirectory
    directory = fs.list path
    pending = directory.length
    for file in directory
      if fs.isDirectory file
        if file != "." and file != ".."
          results = results.concat walk fs.workingDirectory + "/" + file
      if !fs.isDirectory file
        if /\.[md]+$/i.test file
          results.push fs.workingDirectory + "/" + file
      results
      )(path)
        
casper.start "#{config.url}:#{config.port}" + "/article", ->
  @test.info "GET /article -> GET /article/show:id"
  @test.comment "Article index (non-authenticated user)"
  @test.assertTitle config.title, "The title is #{config.title}"
  @test.assertExists ".table", "The table is on the page"
  @test.assertSelectorHasText "ul.nav li.active", "Articles", "And the Articles navbar tab is active"
  @test.assertElementCount "tr", 62, "And the table's rows equal the number of markdown files in the submodule"
  @test.article = casper.fetchText "tr:first-child td:first-child"
  @test.assertSelectorHasText "tr:first-child td a", "Show", "For non-authenticated users the Show article button is visible"
  @test.assertNotVisible "td a.btn-warning", "For non-authenticated users the Edit article button is not visible"
  @test.assertNotVisible "td a.btn-danger", "For non-authenticated users the Delete button is not visible"
  
casper.thenClick "tr:first-child td a", ->
  @test.comment "Article show (non-authenticated user)"
  @test.text = casper.fetchText("ul.breadcrumb").replace(/[\n\r]/g, '').replace(/\s+/g, '')
  @test.assertEqual @test.article, @test.text, "Breadcrumbs match the clicked article's path"
  @test.assertSelectorHasText "ul.nav li:first-child", "Back to articles", "For non authenticated users Back to articles is on the article show page"
  @test.assertNotVisible ".show-edit-article", "For non authenticated users Edit article is not shown on the article show page" 
  @test.assertNotVisible ".show-destroy-article", "For non authenticated users Destroy aritcle is not show on the article show page"  
  
casper.thenClick "ul.nav li:first-child a", ->
  @test.info "GET /article/edit/:id -> PUT /article/update:id"
  @test.assertTitle config.title, "The title is #{config.title}"
  @test.assertExists ".table", "The table is on the page"
  @fill "form[action='/session/create']", 
    email: "test@test.com"
    password: "password"
  , false 
  
casper.then ->
  @test.assertField("email", "test@test.com")
  @test.assertField("password", "password")
  
casper.then ->
  @click "form[action='/session/create'] button[type=submit]"
  @waitForText "New article" 
  
casper.then ->
  @test.comment "Article index (authenticated non-admin user)"
  @test.assertSelectorHasText "ul.nav li.active", "Articles", "Articles tab is active" 
  @test.assertTitle config.title, "The title is #{config.title}"
  @test.assertExists ".table", "The table is on the page"
  @test.assertSelectorHasText "tr:first-child td a", "Show", "For non-authenticated users the Show article button is visible on the article index page"
  @test.assertSelectorHasText "td a.btn-warning", "Edit", "For authenticated users the Edit article button is visible on the article index page"
  @test.assertSelectorHasText "td a.btn-danger", "Destroy", "For authenticated users the Delete article button is visible on the article index page"
  @test.article = casper.fetchText "tr:first-child td:first-child"
  # Todo: add article edit assertions from index
  
casper.thenClick "tr:first-child td a.btn-primary", ->
  @test.comment "Article show (authenticated non-admin user)"
  @test.text = casper.fetchText("ul.breadcrumb").replace(/[\n\r]/g, '').replace(/\s+/g, '')
  @test.assertEqual @test.article, @test.text, "Breadcrumbs match the clicked article's path"
  @test.assertSelectorHasText "ul.nav li:first-child", "Back to articles", "For authenticated users Back to articles is on the article show page"
  @test.assertSelectorHasText "ul.nav li:nth-child(2)", "Download as a pdf", "For authenticated users Download as a pdf is on the article show page"
  @test.assertSelectorHasText ".show-edit-article a", "Edit article", "For authenticated users Edit article is on the article show page"  
  @test.assertSelectorHasText ".show-destroy-article a", "Destroy article", "For authenticated users Destroy article is on the article show page"
    
casper.thenClick ".show-edit-article a", ->
  url = @getCurrentUrl()
  index = url.lastIndexOf "/"
  articleId = url.substr(index)[1..-1]
  config.articleId = articleId
  # This regex compares against a 24 hex character string 
  re = new RegExp "^[0-9a-fA-F]{24}$"
  @test.assertMatch articleId, re, 'Article _id is a valid mongo id'
  @test.assertExists "input[value=Update]", "Article submit button is on the article edit page."
  
casper.thenClick "input[value=Update]", ->
  @test.assertSelectorHasText ".alert p", "Article was successfully updated.", "Success message was displayed."

casper.thenClick "button.close", ->
  @test.assertNotVisible ".alert", "Clicking the 'x' on the alert box removes it from the DOM"  
  
casper.then ->
  @test.info "Authenticated user non-admin: GET /article -> DESTROY /article/:id"
  @test.comment "Article index (authenticated non-admin user) destroy"
  @click ".index-article-show"
  
casper.thenClick ".show-destroy-article a", ->
  @waitForText "Success"
  @test.assertSelectorHasText ".alert p", "Article was destroyed.", "Article destroyed message was displayed."
  # Todo: save article path then test if it's on the index page after destroyed
  
casper.thenClick "button.close", ->
  @test.assertNotVisible ".alert", "Clicking the 'x' on the alert box removes it from the DOM"  
  
casper.then ->
  @test.info "Authenticated user non-admin: GET /article/:id -> DESTROY /article/:id"
  @test.comment "Article show (authenticated non-admin user) destroy"
  
  
  
# casper.then ->
#   @test.info "Authenticated user admin: GET /article/edit/:id -> POST /article/:id"
  
casper.run ->
  @echo "Done!"
  @exit()