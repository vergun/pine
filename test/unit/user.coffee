Sails = require("sails")
UserFactory = require("./factories/user")
# require('../../api/models/user')

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
    
beforeEach (done) ->
  _.each User.find(), (user) ->
    User.destroy user
  done()
  
describe 'UserController', ->  

  describe 'Create a new user', ->
    it 'should be an object', (done) ->
      assert typeof User is "object"
      assert User instanceof Object
      done()
      
    it 'should have a stored name', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert user.name is UserFactory.nonadmin().name
        done()
    
    it 'should have a stored email', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert user.email is UserFactory.nonadmin().email
        done()
        
    it 'should have a stored createdAt', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.createdAt is "object"
        done()
        
    it 'should have a stored updatedAt', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.updatedAt is "object"
        done()
        
    it 'should have an id', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.id is "string"
        done()
        
    it 'should not have a viewable password', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.password is "undefined"
        done()
        
    it 'should not have a viewable _csrf token', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user._csrf is "undefined"
        done()
        
   describe 'Create a duplicate user', ->
     it 'should throw a duplicate error on email', (done) ->
       User.create(UserFactory.nonadmin()).then ->
         User.create UserFactory.nonadmin(), (err, user) ->
           assert typeof err isnt "undefined"
           done()
         
   describe 'Create a nonadmin user', ->
     it 'should not be an admin', (done) ->
       User.create UserFactory.nonadmin(), (err, user) ->
         assert user.admin is false
         done()
         
   describe 'Create an admin user', ->
     it 'should be an admin', (done) ->
       User.create UserFactory.admin(), (err, user) ->
         assert user.admin is true
         done()

after (done) ->
  app.lower 
  done()