/**
 * ArticleController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

var fs = require('fs'), path = require('path');


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
        
        var breadcrumbs = path.normalize(file).split(path.sep);
        
        return res.view({
          article: article,
          file: file,
          breadcrumbs: breadcrumbs,
          user: user
        }) 
      })
    },
    new: function(req, res) {
      var user = req.session.User;
      res.view({
        user: user
      })
    },
    // Create a new article (posted params)
    create: function(req, res, next) {
      
      // Hardcoded for testing
      var file = 'Pine_Needles/contents/articles//01_Get_Started/01_End_Users/01_Free_Trial/03_Discover_Sugar/index.md';
      req.body.file = file
      
      Article.create(req.body, function articleCreated (err, article) {  

        // Return error and redirect if an error
        if (err) {
          req.session.flash = { err: err }
          return res.redirect('/article/new');
        }
      
        // Redirect to view
        res.redirect('/article/' + article.slug);
      });
      
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
    md_to_pdf: function(req, res) {
      var file = req.param('file');
      var pdfPath = "/tmp/article.pdf";
      var opts = {
                   cssPath: '/linker/styles/bootstrap.css'
                 };
      
      Article.convert(file, pdfPath, opts, function() {
        res.download(pdfPath)
      });
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
    },
    
    // Task that seeds db articles from
    // Pine_Needles branch into mongo
    populate: function(req, res) {
      Article.destroy({})
      .then(function() {
        Article.list(appConfig.submodulePath, function(err, articles) {
          articles.files.forEach(function(file) {
            Article.create({file: file}, function(err) {
              if (err) res.send(err);
              if (!err) res.send("ok");
            })
          })       
        })
      })
    }
    
};

module.exports = ArticleController;