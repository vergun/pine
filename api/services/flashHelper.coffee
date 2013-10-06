#
# * Assist with flash messages
# 

module.exports = (->
  
  
  functions = 
    
    update: (req, type, subject, action) ->
      subject = subject.charAt(0).toUpperCase() + subject.slice(1)
      process[type+subject] = [
        name: type+subject
        message: subject.toUpperCase() + " " + action
      ]
      req.session.flash[type] = process[type+subject]    

  functions
  
)()