#---------------------------------------------------------------
#  :: sails-github
#  -> adapter
#---------------------------------------------------------------

fs          = require "fs"
mkdirp      = require "mkdirp"
markdownpdf = require "markdown-pdf" 
PdfHelper   = require "../services/pdfHelper"
wrench      = require "wrench"
git         = require "gift"
path        = require "path"
repo        = git 'Pine_Needles'

global.GitHubHelper = (submodule, file, content, method, next) ->
  @lockfile = '.git/modules/Pine_Needles/index.lock'
  @submodule = submodule
  @file = file
  @content = content
  @method = method
  @next = next
  @

GitHubHelper::writeFile = (callback) -> 
  @create_missing_directories =>
    fs.writeFile @file, @content, (err) =>
      if err
        callback(err)
      else
        callback(null)
      
GitHubHelper::destroyFile = (callback) -> 
  fs.exists @file, (exists) =>
    fs.unlinkSync @file if exists
    callback(null)
      
GitHubHelper::syncRepository = (callback) ->
  log.info "Syncing repository"
  repo.sync @submodule.remote, @submodule.branch, (err) =>
    if err
      callback(err)
    else
      callback(null)

GitHubHelper::add_files_to_git = (callback) -> 
  log.info "Adding files"
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
  log.info "Getting repo status"
  repo.status (err, status) ->
    if status.clean
      err = 
        code: "no_changed_files"
        msg: "No changed files"
      callback(err)
    else
      callback(null)
      
GitHubHelper::commitFiles = (callback) ->  
  log.info "Committing files"
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
  else if "Created" is @method
    repo.commit "Created #{@file}", {}, (err) ->
      if err
        callback(err)
      else
        callback(null)

GitHubHelper::pushFiles = (callback) ->  
  log.info "Pushing files"
  repo.remote_push @submodule.remote + " " + @submodule.branch, (err) ->
    if err
      callback(err)
    else
      callback(null)  

GitHubHelper::prepared_directory = (filepath) ->
  filepath.split(path.sep).slice(0,-1).join(path.sep)
        
GitHubHelper::create_missing_directories = (callback) -> 
  mkdirp.sync @prepared_directory(@file) unless "Created" isnt @method
  if typeof callback is "function" then callback.apply()
  
GitHubHelper::isAFile = (directory) ->
  directory.match(/\.[md|xml|html|htm]+$/i)
  
GitHubHelper::transactionFailed = (err, callback) ->   
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
        @transactionFailed(err, self.next)
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
        @transactionFailed(err, self.next)
      else
        self.next(null) 
    
module.exports = (->
  
  adapter =
    syncable: false
    defaults: {}

    saveWithGit: (collectionName, file, content, method, next) ->
      try
        submodule = appConfig.submodule
        gitHubHelper = new GitHubHelper(submodule, file, content, method, next)
        gitHubHelper.save()
      catch err
        info.log err
        #todo
        
    destroyWithGit: (collectionName, file, content, method, next) ->
      try
        submodule = appConfig.submodule
        gitHubHelper = new GitHubHelper(submodule, file, content, method, next)
        gitHubHelper.destroy()
      catch err
        info.log err
        #todo
        
    read: (collectionName, file, next) ->
      breadcrumbs = path.normalize(file).split(path.sep)
      content = fs.readFileSync file, encoding: 'utf-8'
      article =
        file: file
        content: content
        breadcrumbs: breadcrumbs
 
      next null, article
        
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