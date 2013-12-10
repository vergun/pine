###
StatusController

@module    	  :: Controller
@description	:: Responds with status message
###

module.exports = 
  
  main: (req, res, next) ->
    response =
      scope: "api"
      status: true
      data: null
      code: "online"
      message: "System is running normally since #{startDate}."
    
    res.send 200, response: response