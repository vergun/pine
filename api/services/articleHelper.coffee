yaml  = require 'js-yaml'
fs    = require 'fs-extra'
childProcess = require 'child_process'

_error = (article, callback) ->
  article.headers = null
  error = err:
    message: "Article missing headers or formatted improperly."
    code: "article_missing_header_or_formatted_improperly"
    
  callback(error, article)
  
_parse_headers = (article) ->
  article.content.split("---\n\n")
  
_read_headers = (article, next) ->
  [headers, content] = _parse_headers(article)

  try yaml.safeLoadAll headers, (section) ->
    if typeof section is "object"
    then article.headers = section
    
    article.content = content
    next(null, article)
    
  catch error then next(error, article)
    
_set_headers = (req, next) ->
  headers = _.clone req.params.all()
  delete headers._csrf
  delete headers.content
  delete headers.path
  
  str = "---\n"
  
  Object.keys(headers).forEach (key) ->
    val = headers[key]
    val = val.replace(':', ' -')
    str += '' + key + ': ' + val + '\n'
    
  str += "---\n\n"

  content = str + req.body.content
  req.body.content = content
  
  next(null, req)
  
# Remove the first element from the path array
_get_submodule_path = (path) ->
  filePath = path.split("/")
  filePath.shift()
  filePath = filePath.join("/")
  filePath
  
_read_commits = (article, path, next) ->
  log.info path
  build = childProcess.exec "cd Pine_Needles && git log -5 --graph --pretty=format:'%h -%d %f (%cr) <%an>' -- #{path}", (err, stdout, stderr) =>
    if err
      ErrorLogHelper err.stack, "DIFF:"
      next(err, null)
    else
      article.history =   stdout.split("\n")
            
      SuccessLogHelper stdout, "DIFF:"
      next(null, article)

global.ArticleHelper =
  
  copy: (target, destination, next) ->
    fs.copyRecursive target, destination, (err) ->
      if !err
        next()
    
  move: (target, destination, next) ->
    fs.move target, destination, (err) ->
      if !err
        next()

  readHeaders: (article, callback) ->
    if article?.content
      _read_headers article, (error, article) ->
        callback error, article
    else      
      @error article, callback
      
  setHeaders: (req, callback) ->
    if req
      _set_headers req, (error, req) ->
        callback error, req
    else
      @error article, callback
      
  readCommits: (article, callback) ->
    path = _get_submodule_path(article.path)
    
    _read_commits article, path, (error, article) ->
      callback(error, article)
    
  error: (article, callback) ->
    _error article, callback
    


            
        

  

    