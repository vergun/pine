### Utility methods to act on the
  article model
                          ###  
_format_header_attributes = (headers) ->
  intermmediateHeaders = 
      _.map headers, (pairs) ->
        _.map pairs.split(":"), (attribute) ->
          '"' + attribute.replace(/(^\s+|\s+$|,)/g, '') + '"'
      
  joinedHeaders = _.map intermmediateHeaders, (header) ->
    header.join(":")
        
  joinedHeaders = JSON.parse "{" + joinedHeaders.join(",") + "}"    
  
  joinedHeaders
  
_prepare_header_pairs = (headers) ->
  (_.compact( headers.replace("---\n", "").split("\n") ).join(", ")).split(",")
  
_format_holder_content = (article) ->
  article.content.split("---\n\n")
  
global.ArticleHelper = (article, callback) ->
    holder = _format_holder_content article
    article.headers = _format_header_attributes _prepare_header_pairs holder[0]
    article.content = holder[1]
    
    unless article.headers && article.content
      error = err:
          message: "Article improperly formatted."
          code: "improper_article_format"
          
    callback error, article
    