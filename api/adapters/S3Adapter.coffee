#---------------------------------------------------------------
#  :: sails-s3
#  -> adapter
#---------------------------------------------------------------

config        = _.extend s3Config, logger: log
aws           = require('aws-sdk')
fs            = require('fs')
s3            = new aws.S3()

s3.config.update(config)

global.S3Helper = (req, file, next) ->
  @req = req
  @file = file
  @next = next
  @
  
S3Helper::put = (path) ->
  log.info "PATH"
  log.info path
  config = 
    ACL: "public-read-write"
    Key: path
    Bucket: s3Config.bucket
        
  fs.readFile path, (err, data) =>
    _.extend config, Body: data
    
    log.error err if err
    s3.putObject config, (err, response) =>
      log.error err if err
      
      log.info response if response
      @next()
  
#todo needs work
S3Helper::remove = () ->
  s3.deleteObject object, (err, data) =>
    log.info data
    @next()
  
S3Helper::listBuckets = () ->
  s3.listBuckets (err, data) -> 
    log.info data 
    @next()
      
module.exports = (->
  
  adapter =
    identity: "sails-s3"
    syncable: false
    defaults: {}
    
    putS3: (collectionName, req, file, next) ->
      try 
        s3Helper = new S3Helper(req, file, next)
        s3Helper.put file
      catch err
        ErrorLogHelper err, "S3:"
        self.next(err, null)
        
    removeS3: (collectionName, req, file, next) ->
      try 
        s3Helper = new S3Helper(req, file, next)
        s3Helper.remove()
      catch err
        ErrorLogHelper err, "S3:"
        self.next(err, null)
        
    listBuckets: (collectionName, req, next) ->
      try 
        s3Helper = new S3Helper(req, next)
        s3Helper.listBuckets()
      catch err
        ErrorLogHelper err, "S3:"
        self.next(err, null)
        
  adapter
)()