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

# class GitHubHelper extends repo
#   constructor: () ->
#   lockfile: '.git/modules/Pine_Needles/index.lock'
#   branch: appConfig.submodule.branch
#   
# GitHubHelper:: = repo
# gitHubHelper = new GitHubHelper()
 
    
module.exports = (->
  
  adapter =
    syncable: false
    defaults: {}
    registerCollection: (collectionName, cb) ->
      self = this
      cb()

    teardown: (cb) ->
      cb()  if cb

    saveWithGit: (collectionName, file, content, next) ->
      fs.writeFile file, content, (err) =>
        if err 
          next(err, null)
        else
          repo.sync "origin", appConfig.submodule.branch, (err) =>
            repo.add ".", (err) ->
              fs.exists '.git/modules/Pine_Needles/index.lock', (exists) =>
                fs.unlinkSync '.git/modules/Pine_Needles/index.lock' if exists
                repo.status (err, status) =>
                  if status.clean
                    next(null, file)
                  else
                    repo.commit "Updated #{file}", {}, (err) => 
                      if err
                        next(err)
                      else
                        repo.remote_push "origin " + appConfig.submodule.branch, (err) =>
                          if err
                            next(err)
                          else
                            next(null, file)

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