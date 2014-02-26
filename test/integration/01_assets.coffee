###
  JavaScripts
  Images
  Stylesheets
  ###

# Configuration options
config =
  port: '1337'
  url: 'http://localhost'
  title: 'Pine'

# Assets #
scriptsArray = imagesArray = stylesArray = []  

getScripts = ->
  scripts = document.querySelectorAll("script[src]")
  Array::map.call scripts, (e) ->
    e.getAttribute "src"
    
getImages = ->
  images = document.querySelectorAll("img[src]");
  Array::map.call images, (e) ->
    e.getAttribute "src"
    
getStyles = ->
  styles = document.querySelectorAll("link[href]");
  Array::map.call styles, (e) ->
    e.getAttribute "href"

casper.echo "GET /articles/index (verify javascript assets are received)"
casper.start "#{config.url}:#{config.port}", ->
  scriptsArray = @evaluate(getScripts)
  scriptsArray.forEach (item) =>
    if @resourceExists(item)
      @echo item + " loaded"
    else
      @echo item + " not loaded", "ERROR"

casper.echo "GET /articles/index (verify image assets are received)"
casper.then ->
  imagesArray = @evaluate(getImages)
  imagesArray.forEach (item) =>
    if @resourceExists(item)
      @echo item + " loaded"
    else
      @echo item + " not loaded", "ERROR"
      
casper.echo "GET /articles/index (verify stylesheet assets are received)"
casper.then ->
  stylesArray = @evaluate(getStyles)
  stylesArray.forEach (item) =>
    if @resourceExists(item)
      @echo item + " loaded"
    else
      @echo item + " not loaded", "ERROR"

      
