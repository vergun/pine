Sails = require("sails")

app = undefined

before (done) ->
  
  @timeout 5000
  
  Sails.lift
    log:
      level: "error"

    adapters:
      default: 'memory'
      memory:
        module: "sails-memory"
        host: "localhost"
        database: "test_database"
        user: ""
        pass: ""

  , (err, sails) ->
    app = sails
    done err, sails   
    

after (done) ->
  app.lower 
  done()