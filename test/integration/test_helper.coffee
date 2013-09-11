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