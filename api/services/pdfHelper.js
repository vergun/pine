/*
 * Assist with pdf conversions
 */

module.exports = (function() {
      
  functions = {
  
    convert: function(file, opts, pdfPath, next) {
      
      markdownpdf(file, opts, function(err, returnedPath) {
    
        if (err) return console.error(err);          
    
        fs.rename(returnedPath, pdfPath, function() {
          next();
        })
      });
      
    } 
  
  }
  
  return functions;

})(); 

