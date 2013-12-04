yaml = require('js-yaml')
fs = require('fs')

_error = (article, callback) ->
  article.headers = null
  error = err:
    message: "Article missing headers or formatted improperly."
    code: "article_missing_header_or_formatted_improperly"
    
  callback(error, article)
  
  
_read_headers = (article, next) ->
  try yaml.safeLoadAll article.content, (section) ->
    if typeof section is "object" 
    then article.headers = section 
    else article.content = section
  
    article.counter = ++article.counter || 1
  
    next(null, article) if article.counter is 2
    
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
  
  content = str + req.param("content") 
  req.query.content = content
  
  fs.writeFile req.param("path"), req.param("content"), (err) ->
    if err
      next(err)
    else
      next(null, req)

  
### Utility methods to act on the
  article model
                          ###  

global.ArticleHelper =
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
    


            
        

  

    