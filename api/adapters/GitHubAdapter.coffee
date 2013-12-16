#---------------------------------------------------------------
#  :: sails-github
#  -> adapter
#---------------------------------------------------------------

fs          = require "fs"
mkdirp      = require "mkdirp"
wrench      = require "wrench"
git         = require "gift"
path        = require "path"
repo        = git 'Pine_Needles'


global.GitHubHelper = (collectionName, req, file, content, method, next) ->
  @lockfile = '.git/modules/Pine_Needles/index.lock'
  @submodule = appConfig.submodule
  @collectionName = collectionName.charAt(0).toUpperCase() + collectionName.slice(1)
  @req = req
  @file = file
  @content = content
  @method = method
  @next = next
  @

GitHubHelper::progressEmitter = (message, amount) ->
  global[@collectionName]["publish"] @req, type: "progress-bar", message: message, amount: amount, method: @method

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
  @progressEmitter "Syncing repository", 20
  repo.sync @submodule.remote, @submodule.branch, (err) =>
    if err
      callback(err)
    else
      callback(null)

GitHubHelper::add_files_to_git = (callback) -> 
  log.info "Adding files"
  @progressEmitter "Adding files", 20
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
  @progressEmitter "Getting repo status", 20
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
  @progressEmitter "Committing files", 20
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
  @progressEmitter "Pushing files", 20
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
      # @pushFiles.bind(@)
    ],
    (err) =>
      if err
        ErrorLogHelper err, "GITHUB:"
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
      # @pushFiles.bind(@)
    ],
    (err) =>
      if err
        ErrorLogHelper err, "GITHUB:"
        @transactionFailed(err, self.next)
      else
        self.next(null) 
    
module.exports = (->
  
  adapter =
    identity: "sails-github"
    syncable: false
    defaults: {}

    saveWithGit: (collectionName, req, file, content, method, next) ->
      try
        gitHubHelper = new GitHubHelper(collectionName, req, file, content, method, next)
        gitHubHelper.save()
      catch err
        ErrorLogHelper err, "GITHUB:"
        self.next(err, null)
        
    destroyWithGit: (collectionName, req, file, content, method, next) ->
      try
        gitHubHelper = new GitHubHelper(collectionName, req, file, content, method, next)
        gitHubHelper.destroy()
      catch err
        ErrorLogHelper err, "GITHUB:"
        self.next(err, null)
        
    read: (collectionName, filename, next) ->
      name = filename.replace(appConfig.submodule.path, "")
      content = fs.readFileSync filename, encoding: "utf-8"
      breadcrumbs = path.normalize(filename).split(path.sep)
      _path = filename
      article =
        name: name
        content: content
        breadcrumbs: breadcrumbs
        path: _path
 
      next null, article
      
    list: (collectionName, filename, next) ->
      results = adapter.dirTree filename
      next results
 
    dirTree: (filename) ->
      stats = fs.lstatSync filename
      info = 
        path: path.normalize filename
        name: path.basename filename
      
      if stats.isDirectory()
        info.type = "folder"
        info.children = fs.readdirSync(filename).map (child) -> adapter.dirTree(filename + "/" + child)
      else
        info.type = "file"
      
      info
      
  adapter
)()