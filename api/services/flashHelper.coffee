#
# * Assist with flash messages
# 

module.exports = (->
  
  
  functions = 
    
    # @param : req
    # @param : type    [info, error, success]
    # @param : subject [article, user]
    # @param : action  describes what the subject is doing
    
    msg: (req, type, subject, action) ->
      subject = subject.charAt(0).toUpperCase() + subject.slice(1)
      process[type+subject] = [
        name: type+subject
        message: subject + " " + action
      ]
      if req.session.flash
        req.session.flash[type] = process[type+subject]    

  functions
  
)()