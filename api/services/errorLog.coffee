mkdirp = require('mkdirp')
moment = require('moment')
fs = require('fs')
 
### Update the console logger 
  and update output from the console
  logger to a file system
                          ###

class FileLogger extends log.transports.File
  constructor: () ->
    
  LOGGER_TIMESTAMP_FORMAT: 'MM-DD HH:mm:ss'
  LOGLEVELS:
    levels:
      info: 10
      error: 20
      warn: 30
      db: 40
      req: 50
      none: 60
    colors:
      info: 'green'
      error: 'red'
      warn: 'yellow'
      db: 'cyan'
      req: 'magenta'
      none: 'grey'
  loggerLevel: 'warn'
    
FileLogger::dirname = ->
  "./log/#{@date()}/"
    
FileLogger::filename = ->
  @dirname() + "pine.log"
   
FileLogger::date = ->
  moment().format "YYYYMMDD" 

FileLogger::loggerLevel = ->
  _.find _.keys(@LOGLEVELS.levels), (key) => key == appConfig.logger_level

FileLogger::timestampFormat = ->
  moment().format @LOGGER_TIMESTAMP_FORMAT
  
FileLogger::makeLogDirectory = ->
  mkdirp.sync @dirname()
  
FileLogger::options = ->
  timestampFormat = @timestampFormat()
  loggerLevel = @loggerLevel()
  filename = @filename()
    
  options =
    colorize: true
    json: false
    timestamp: timestampFormat
    loggerLevel: loggerLevel
    filename: filename

FileLogger::addTransports = (options) ->
  options ||= _.extend @options(), filename: undefined
  log.remove(log.transports.Console)
     .add(log.transports.Console, options)
     
  _.extend options, filename: @filename(), json: true
  log.add log.transports.File, options

FileLogger::setLevelsAndColors = ->
  log.setLevels @LOGLEVELS.levels
  log.addColors @LOGLEVELS.colors

FileLogger::run = ->
  @makeLogDirectory()
  @addTransports()
  @setLevelsAndColors()
     
fileLogger = new FileLogger()
fileLogger.run()

global.ErrorLogHelper = (err, prefix) ->
  prefix = "LOG: " unless prefix
  log.warn prefix + "INTERNAL ERROR:"
  log.warn prefix + "Message: " + err.message
  log.warn prefix + JSON.stringify(err, ' ', null)
  log.warn prefix + "Type: " + err.type
  log.warn prefix + "Arguments: " + err.arguments
  log.warn prefix + "Stack: " + err.stack