/**
 * ArticleController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

var fs = require('fs')

var ArticleController = {
    index: function(req, res) {  
      var path = appConfig.submodulePath + "01_Get_Started/01_End_Users";
      Article.list(path, res);
    },
    show: function(req, res) {
      var file = req.param('file')
      console.log(file)
      Article.fetch(file, function(err, article) {
        if (err) return res.send(err)
        if (!article) return res.send({err: {message: "Article not found."}})
        return res.view({
          article: article,
          file: file
        }) 
      })
    },
    edit: function(req, res) {
      var file = req.param('file')
      Article.fetch(file, function(err, article) { 
        if (err) return res.send(err)
        if (!article) return res.send({err: {message: "Article not found."}})
        return res.view({
          article: article,
          file: file
        }) 
      })
    },
    update: function(req, res) {
      Article.update(req.param('file'), req.param('content'), function(er, res) {
        //render show view
      }) 
    },
    open: function(req, res) {
        var file = req.param('file');
        fs.readFile('files/' + file, function(err, data){
            if (err) res.send("Couldn't open file: " + err.message);
            else res.send(data);
        });
    },
    save: function(req, res) {
        Article.save(req.param('file'), req.param('content'), res)
    }
};

module.exports = ArticleController;