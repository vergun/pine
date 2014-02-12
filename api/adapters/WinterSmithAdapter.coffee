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
  
  
### Works:

Build a single folder:
  
(1) Get all folders into a comma delimited list
(2) Pass current tree and build tree as arguments
(3) Pass ignore as folder list
(4) call on build with options

wintersmith build --ignore 01_Documentation,03_Community --contents contents/articles/01_Get_Started/03_Developers --output build/articles/01_Get_Started/03_Developers --verbose 

###
WinterSmithHelper::build = () ->
  Article.list @file, (results) =>
    if results
      if results.type == "file"
        filePath = results.path.split("/").slice(0,-1).join("/")
      if results.type == "directory"
        filePath = results.path
        
      Article.list filePath, (results) =>
        folders = (x.name for x in results.children when x.type is "folder")
        folders = folders.join(",")
        
        buildPath = filePath.split("/")
        buildPath[1] = "build" if buildPath[1] == "contents"
        buildPath = buildPath.join("/")
        
        build = childProcess.exec "wintersmith build --ignore #{folders} --contents #{filePath} --output #{buildPath} --verbose", (err, stdout, stderr) =>
          if err
            ErrorLogHelper err.stack, "WINTERSMITH:"
            @next(err, null)
          else
            log.info stdout
            SuccessLogHelper stdout, "WINTERSMITH:"
            @next(null, {success:true})
            
      
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