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

global.GitHubHelper = (file, content, method, next) ->
  @lockfile = '.git/modules/Pine_Needles/index.lock'
  @file = file
  @content = content
  @method = method
  @next = next
  @

GitHubHelper::writeFile = (callback) -> 
  fs.writeFile @file, @content, (err) ->
    if err
      callback(err)
    else
      callback(null)
      
GitHubHelper::destroyFile = (callback) -> 
  fs.exists @file, (exists) =>
    fs.unlinkSync @file if exists
    callback(null)
      
GitHubHelper::syncRepository = (callback) ->
  repo.sync "origin", appConfig.submodule.branch, (err) =>
    if err
      callback(err)
    else
      callback(null)

GitHubHelper::add_files_to_git = (callback) ->  
  repo.add "-A", (err) ->
    if err
      callback(err)
    else
      callback(null)
  
GitHubHelper::remove_index_lock_file = (callback) ->  
  fs.exists @lockfile, (exists) =>
    fs.unlinkSync @lockfile if exists
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
  if "Updated" is @method
    repo.commit "Updated #{@file}", {}, (err) ->
      if err
        callback(err)
      else
        callback(null)
  else if "Deleted" is @method
    repo.commit "Deleted #{@file}", {}, (err) ->
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
  
GitHubHelper::failed_destroy = (err, callback) ->   
  callback(err, @file)
                  
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
        
GitHubHelper::destroy = (file, content, next) ->
  self = this
  async.waterfall [
      @destroyFile.bind(@)
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
        @failed_destroy(err, self.next)
      else
        self.next(null)  
    
module.exports = (->
  
  adapter =
    syncable: false
    defaults: {}

    saveWithGit: (collectionName, file, content, method, next) ->
      try
        gitHubHelper = new GitHubHelper(file, content, method, next)
        gitHubHelper.save()
      catch err
        info.log err
        #todo
        
    destroyWithGit: (collectionName, file, content, method, next) ->
      try
        gitHubHelper = new GitHubHelper(file, content, method, next)
        gitHubHelper.destroy()
      catch err
        info.log err
        #todo

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