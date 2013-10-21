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
        
    populateArticles: (next) ->
      results = []
      Article.destroy({}).then ->
        Article.list appConfig.submodule.path, (articles) ->
          articlesLength = articles.length
          currentNumber = 1
          articles.forEach (file) ->
            Article.create
              file: file
            , (err) ->
              results.push appConfig.submodule.path + file
              currentNumber++
              if currentNumber is articlesLength
                next(results)

  functions
  
)()