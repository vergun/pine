#---------------------------------------------------------------
#  :: sails-github
#  -> adapter
#---------------------------------------------------------------

fs          = require "fs"
markdownpdf = require "markdown-pdf" 
PdfHelper   = require "../services/pdfHelper"
wrench      = require "wrench"
git         = require "gift"
repo        = appConfig.submodulePath

module.exports = (->
  
  adapter =
    syncable: false
    defaults: {}
    registerCollection: (collectionName, cb) ->
      self = this
      cb()

    teardown: (cb) ->
      cb()  if cb

    _update: (collectionName, file, content, next) ->
      afterSave = ->
        spawn = require("child_process").spawn
        postReceive = spawn("sh", ["post-receive.sh"],
          cwd: process.cwd()
          env: _.extend(process.env,
            PATH: process.env.PATH + ":/usr/local/bin"
          )
        )
      file = file
      content = content
      fs.writeFile appConfig.submodulePath + file, content, (err, data) ->
        if err
          res.send error:
            message: "Couldn't write file."


      afterSave()
      next.send ok:
        message: "File written."

    refresh: (collectionName, file, content, next) ->
      afterSave = ->
      #   spawn = require("child_process").spawn
      #   postReceive = spawn("sh", ["post-receive.sh"],
      #     cwd: process.cwd()
      #     env: _.extend(process.env,
      #       PATH: process.env.PATH + ":/usr/local/bin"
      #     )
      #   )
      # file = file
      # content = content
      # fs.writeFile file, content, (err, data) ->
      #   if err
      #     return res.send(error: [
      #       name: "fileWriteError"
      #       message: "Couldn't write file."
      #     ])
      #   afterSave()
      #   next err,
      #     file: file
      #     content: content

    convert: (collectionName, file, pdfPath, opts, next) ->
      file = file
      pdfPath = pdfPath
      opts = opts
      PdfHelper.convert file, opts, pdfPath, next

    list: (collectionName, path, next) ->   
      results = new Array()  
      _.each wrench.readdirSyncRecursive(path), (file) ->
        results.push(file) if file.match(/\.[md]+$/i)
      
      next results

  adapter
)()