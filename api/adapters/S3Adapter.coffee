#---------------------------------------------------------------
#  :: sails-s3
#  -> adapter
#---------------------------------------------------------------

config        = _.extend s3Config, logger: log
aws           = require('aws-sdk')
s3            = new aws.S3()


aws.config.update(config)

global.S3Helper = (req, file, next) ->
  @req = req
  @file = file
  @next = next
  @
  
S3Helper::put = () ->
  @next()
      
module.exports = (->
  
  adapter =
    identity: "sails-s3"
    syncable: false
    defaults: {}
    
  putS3: (collectionName, req, file, next) ->
    try 
      s3Helper = new S3Helper(req, file, next)
      s3Helper.put()
    catch err
      ErrorLogHelper err, "S3:"
      self.next(err, null)
    
  adapter
)()