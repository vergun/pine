#---------------------------------------------------------------
#  :: sails-github
#  -> adapter
#---------------------------------------------------------------

fs          = require "fs"
markdownpdf = require "markdown-pdf" 
PdfHelper   = require "../services/pdfHelper"
wrench      = require "wrench"
git         = require "gift"
repo        = git 'Pine_Needles'

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
      fs.writeFile file, content, (err) ->
        if err 
        else
          repo.sync "origin", appConfig.submodule.branch, (err) ->
            repo.status (err, status) ->
            repo.add ".", (err) ->
            repo.commit "new message", {}, (err) -> 
              # repo.commit is throwing an err, investigate
              console.log err
              # repo.remote_pull "--rebase origin " + appConfig.submodule.branch, (err) ->
              #   console.log "pull"
              repo.remote_push "origin " + appConfig.submodule.branch, (err) ->


    refresh: (collectionName, file, content, next) ->
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
      fs.writeFile file, content, (err, data) ->
        if err
          return res.send(error: [
            name: "fileWriteError"
            message: "Couldn't write file."
          ])
        afterSave()
        next err,
          file: file
          content: content

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