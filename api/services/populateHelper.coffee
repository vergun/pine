#
# * Assist with population tasks
# 

module.exports = (->
  
  functions = 
    
    populateUsers: (next) ->
    
      users = []
    
      admin =
        name: "Admin User"
        email: "admin@test.com"
        password: "password"
        confirmation: "password"
        admin: [
          "checked"
          "on"
        ]
    
      nonadmin =
        name: "Nonadmin User"
        email: "nonadmin@test.com"
        password: "password"
        confirmation: "password"
      
      _.each [admin, nonadmin], (user) ->
        User.findOrCreate email: user.email, user, userCreated = (err, user) ->        
          user["_password"] = "password"
        
          users.push user
          if users.length is 2
            if next?
              next(users)

  functions
  
)()