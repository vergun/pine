###
  Routine::Hash
  Teardown::Array
  ###

# Routine #
var routine = {}
routine.login = (email, password) ->
  casper.open(url)
  casper.waitUntilVisible 'form', ->
    @fill 'form'
      'email': email
      'password:': password
    , true
  casper.waitForSelector '#yourUserName', ->
    @echo 'Logged in', null
    

# Teardown #
var teardownSteps = []

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
        