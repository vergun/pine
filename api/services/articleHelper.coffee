### Utility methods to act on the
  article model
                          ###

run = (article) ->
  
_format_header_attributes = (headers) ->
  unjoinedHeaders = _.compact( headers.replace("---\n", "").split("\n") ).join(", ")
  intermmediateHeaders = 
    _.map unjoinedHeaders.split(","), (header) ->
     _.map header.split(":"), (attribute) ->
       '"' + attribute.replace(/(^\s+|\s+$|,)/g, '') + '"'
       
  joinedHeaders = _.map intermmediateHeaders, (header) ->
    header.join(":")
    
  joinedHeaders = "{" + joinedHeaders.join(",") + "}"
    
  joinedHeaders = JSON.parse(joinedHeaders)
  log.info joinedHeaders
  
  
  joinedHeaders
  
  
global.ArticleHelper = (article, callback) ->
    
    holder = article.content.split("---\n\n")
    article.headers = _format_header_attributes holder[0]
    article.content = holder[1]
    unless article.headers && article.content
      error = err:
          message: "Article improperly formatted."
          code: "improper_article_format"
    callback error, article
    