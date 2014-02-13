yaml  = require 'js-yaml'
fs    = require 'fs-extra'

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
  
### Utility methods to act on the
  article model
                          ###  

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
    
  error: (article, callback) ->
    _error article, callback
    


            
        

  

    