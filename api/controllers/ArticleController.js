/**
 * ArticleController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

var fs = require('fs')

var ArticleController = {
    index: function(req, res) {  
      
      var user = req.session.User;
      
      Article.list(appConfig.submodulePath, function(err, articles) {
        if (err) return res.send(err);
        res.view({
          articles: articles.files,
          user: user
        })
      });
    },
    show: function(req, res) {
      var file = req.param('file'), user = req.session.User;
      
      Article.fetch(file, function(err, article) {
        if (err) return res.send(err)
        if (!article) return res.send({err: {message: "Article not found."}})
        
        var breadcrumbs = file.split("/");
        
        return res.view({
          article: article,
          file: file,
          breadcrumbs: breadcrumbs,
          user: user
        }) 
      })
    },
    new: function(req, res) {
      res.view({})
    },
    edit: function(req, res) {
      
      var user = req.session.User;
      
      var file = req.param('file')
      Article.fetch(file, function(err, article) { 
        if (err) return res.send(err)
        if (!article) return res.send({err: {message: "Article not found."}})
        
        return res.view({
          article: article,
          file: file,
          user: user
        }) 
      })
    },
    update: function(req, res) {      
      Article.refresh(req.param('file'), req.param('content'), function(err, article) {
        res.redirect('/article');
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