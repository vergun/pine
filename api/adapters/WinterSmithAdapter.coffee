#---------------------------------------------------------------
#  :: sails-wintersmith
#  -> adapter
#---------------------------------------------------------------

childProcess  = require "child_process"
fs            = require "fs"

global.WinterSmithHelper = (req, file, next) ->
  @req = req
  @file = file
  @next = next
  @
  
WinterSmithHelper::build = () ->
  build = childProcess.exec "wintersmith build #{@file}", (err, stdout, stderr) ->
    if error
      ErrorLogHelper err.stack, "WINTERSMITH:"
      @next(err, null)
    else
      # SuccessLogHelper stdout, "WINTERSMITH:"
      # @next(null, null)

  # build.on "exit", (code) ->
  #   SuccessLogHelper code, "WINTERSMITH exited with code:"
  #   @next(null, null)
      
module.exports = (->
  
  adapter =
    identity: "sails-wintersmith"
    syncable: false
    defaults: {}
    
  buildWintersmith: (collectionName, req, file, next) ->
    try 
      winterSmithHelper = new WinterSmithHelper(req, file, next)
      winterSmithHelper.build()
    catch err
      ErrorLogHelper err, "WINTERSMITH:"
      self.next(err, null)
    
  adapter
)()