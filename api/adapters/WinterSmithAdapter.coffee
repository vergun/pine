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
  Article.list @file, (results) ->
    if results
      if results.type == "file"
        filePath = results.path.split("/").slice(0,-1).join("/")
      if results.type == "directory"
        filePath = results.path
        
      Article.list filePath, (results) ->
        ### Works:

        (1) Get all folders into a comma delimited list
        (2) Pass current tree and build tree as arguments
        (3) Pass ignore as folder list
        (4) call on build with options

        wintersmith build --ignore 01_Documentation,03_Community --contents contents/articles/01_Get_Started/03_Developers --output build/articles/01_Get_Started/03_Developers --verbose 

        ###

    if @next && typeof @next is "function"
      @next()
    
    
  # build = childProcess.exec "wintersmith build #{@file}", (err, stdout, stderr) ->
  #   if error
  #     ErrorLogHelper err.stack, "WINTERSMITH:"
  #     @next(err, null)
  #   else
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

    
    buildForWintersmith: (collectionName, req, file, next) ->
      try 
        winterSmithHelper = new WinterSmithHelper(req, file, next)
        winterSmithHelper.build()
      catch err
        ErrorLogHelper err, "WINTERSMITH:"
        self.next(err, null)
    
  adapter
)()