UserFactory = require("./factories/user")
    
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
        
    it 'should have an email of type string', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.email is "string"
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
        
    it 'should have an id that represents a valid BSON Object', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert /^[0-9a-fA-F]{24}$/.test(user.id) is true
        done()
        
    it 'should not have a viewable password confirmation', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.confirmation is "undefined"
        done()
        
    it 'should not have a viewable password', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.password is "undefined"
        done()
        
    it 'should not have a viewable encrypted password', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user.encryptedPassword is "undefined"
        done()
        
    it 'should not have a viewable _csrf token', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert typeof user._csrf is "undefined"
        done()
        
    it 'should default to a non-admin', (done) ->
      User.create UserFactory.nonadmin(), (err, user) ->
        assert user.admin is false
        done()
        
    it 'should allow a non-admin to become an admin', (done) ->
      User.create _.extend(UserFactory.nonadmin(), admin: ["checked", "on"]), (err, user) ->
        assert user.admin is true
        done()
        
    it 'should throw an error if an email is not provided', (done) ->
      user = UserFactory.nonadmin()
      delete user.email
      User.create user, (err, user) ->
        assert Object.keys(err["ValidationError"])[0] is "email"
        done()
        
    it 'should not support inserting attributes besides createdAt, updatedAt, email, admin, id, and name', (done) ->
      User.create _.extend(UserFactory.nonadmin(), admin: ["checked", "on"], happy: true, andKnowsIt: true), (err, user) ->
        assert Object.keys(user).indexOf "happy"      is -1
        assert Object.keys(user).indexOf "andKnowsIt" is -1
        done()
        
    it 'should test that an email is a valid email before creation', (done) ->
      User.create _.extend(UserFactory.nonadmin(), email: "myFakeEmail"), (err, user) ->
        assert Object.keys(err["ValidationError"])[0] is "email"
        done()
        
   describe 'Create a duplicate user', ->
     it 'should throw an error if the email is already taken', (done) ->
       User.create(UserFactory.nonadmin()).then ->
         User.create UserFactory.nonadmin(), (err, user) ->
           assert /dup key/.test(err.err) is true
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