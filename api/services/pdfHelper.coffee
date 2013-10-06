#
# * Assist with pdf conversions
# 
module.exports = (->
  functions = convert: (file, opts, pdfPath, next) ->
    markdownpdf file, opts, (err, returnedPath) ->
      return console.error(err)  if err
      fs.rename returnedPath, pdfPath, ->
        next()



  functions
)()