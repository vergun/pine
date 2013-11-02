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

global.GitHubHelper = (file, content, next) ->
  @file = file
  @content = content
  @next = next
  @

GitHubHelper::writeFile = (callback) -> 
  fs.writeFile @file, @content, (err) ->
    if err
      callback(err)
    else
      callback(null)
      
GitHubHelper::syncRepository = (callback) ->
  repo.sync "origin", appConfig.submodule.branch, (err) =>
    if err
      callback(err)
    else
      callback(null)

GitHubHelper::add_files_to_git = (callback) ->  
  repo.add ".", (err) ->
    if err
      callback(err)
    else
      callback(null)
  
GitHubHelper::remove_index_lock_file = (callback) ->  
  fs.exists '.git/modules/Pine_Needles/index.lock', (exists) ->
    fs.unlinkSync '.git/modules/Pine_Needles/index.lock' if exists
    callback(null)
    
GitHubHelper::get_repository_status = (callback) ->  
  repo.status (err, status) ->
    if status.clean
      err = 
        code: "no_changed_files"
        msg: "No changed files"
      callback(err)
    else
      callback(null)
      
GitHubHelper::commitFiles = (callback) ->  
  repo.commit "Updated #{@file}", {}, (err) ->
    if err
      callback(err)
    else
      callback(null)
      
GitHubHelper::pushFiles = (callback) ->  
  repo.remote_push "origin " + appConfig.submodule.branch, (err) ->
    if err
      callback(err)
    else
      callback(null)  
      
      
GitHubHelper::failed_save = (err, callback) ->   
  callback(err)
                  
GitHubHelper::save = (file, content, next) ->
  self = this
  async.waterfall [
      @writeFile.bind(@)
      @syncRepository.bind(@)
      @add_files_to_git.bind(@)
      @remove_index_lock_file.bind(@)
      @get_repository_status.bind(@)
      @commitFiles.bind(@)
      @pushFiles.bind(@)
    ],
    (err) =>
      if err
        # todo
        # article saved without changes
        @failed_save(err, self.next)
      else
        self.next(null, @file)  
    
module.exports = (->
  
  adapter =
    syncable: false
    defaults: {}

    saveWithGit: (collectionName, file, content, next) ->
      try
        gitHubHelper = new GitHubHelper(file, content, next)
        gitHubHelper.save()
      catch err
        # todo
        # InternalErrorResponseHelper err, params, req, res, next

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