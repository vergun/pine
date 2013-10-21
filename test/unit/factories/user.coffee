UserFactory = 
  
  nonadmin: ->
    name: "Joe"
    email: "nonadmin@test.com"
    password: "password"
    confirmation: "password"
    
  admin: ->
    name: "Joe"
    email: "admin@test.com"
    password: "password"
    confirmation: "password"
    admin: [
      "checked"
      "on"
    ]

module.exports = UserFactory