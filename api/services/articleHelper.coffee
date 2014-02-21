yaml  = require 'js-yaml'
fse   = require 'fs-extra'
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
  
  build = childProcess.exec "cd Pine_Needles && git log -5 --graph --pretty=format:'%h\,%H\,%f\,%cr\,%an\,%ae' -- #{path}", (err, stdout, stderr) =>
    if err
      ErrorLogHelper err.stack, "DIFF:"
      next(err, null)
    else
      [lines, history] = [stdout.split("\n"), []]    
      for line, i in lines
        line = line.split("\,")
        history[i] = 
          short_hash: line[0]
          long_hash: line[1]
          subject: line[2]
          commit_date: line[3]
          author_name: line[4]
          author_email: line[5]
    
      if _.first(history)["long_hash"] and _.first(history)["short_hash"]
        article.history = history

      next(null, article)
      
_get_diff = (commit, path, next) ->
  
  build = childProcess.exec "cd Pine_Needles && git diff #{commit} -- #{path}", (err, stdout, stderr) =>
    if err
      ErrorLogHelper err.stack, "DIFF:"
      next(err, null)
    else
      article =
        diff: stdout
        
      next(null, article)

global.ArticleHelper =
  
  copy: (source, destination, next) ->
    stats = fse.lstatSync source
    if stats.isDirectory()
      fse.copyRecursive source, destination, (err) ->
        if !err
          next()
    else
      fse.copy source, destination, (err) ->
        if !err
          next()
     
  move: (source, destination, next) ->
    stats = fse.lstatSync source
    if stats.isDirectory()
      fse.copyRecursive source, destination, (err) ->
        fse.unlink source, (err) ->
          if !err
            next()
    else
      fse.copy source, destination, (err) ->
        fse.unlink source, (err) ->
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
      
  getDiff: (commit, path, callback) ->
    path = _get_submodule_path path
    
    _get_diff commit, path, (error, article) ->
      callback(error, article)
    
  readCommits: (article, callback) ->
    path = _get_submodule_path(article.path)
    
    _read_commits article, path, (error, article) ->
      callback(error, article)
    
  error: (article, callback) ->
    _error article, callback
    


            
        

  

    