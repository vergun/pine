/**
 * ArticleController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

var fs = require('fs'), path = require('path');


var ArticleController = {
  
    index: function(req, res) {  
            
      Article.find(function foundArticles(err, articles) {

        if (err) return next(err);
      
        res.view({ 
          articles: articles
        });
      
      })
    },
    
    show: function(req, res) {
            
      Article.findOne(req.param('id'), function articleFound (err, article) {
      
        if (err) return next(err);
      
        if (!article) {
          req.session.flash = { err: "Article couldn't be found" };
          return next();
        }
      
        var breadcrumbs = path.normalize(article.file).split(path.sep);
        
        var content = fs.readFileSync(article.file);        
      
        res.view({
          article: article,
          content: content,
          breadcrumbs: breadcrumbs
        })

      })
    },
    
    new: function(req, res) {
      res.view({})
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
            
      Article.findOne(req.param('id'), function articleFound (err, article) {
      
        if (err) return next(err);
        
        if (!article) {
          req.session.flash = { err: "Article couldn't be found" };
          return next();
        }
        
        var content = fs.readFileSync(article.file);        
        
        res.view({
          article: article,
          content: content
        })
      })
    },
    update: function(req, res) {      
      Article.refresh(req.param('file'), req.param('content'), function(err, article) {
        res.redirect('/article');
      })
    },
    
    // Article :: convert
    // Turns parsed markdown
    // into downloadable pdf
    convert: function(req, res) {
      
      Article.findOne(req.param('id'), function articleFound (err, article) {
      
        if (err) return next(err);
        
        if (!article) {
          req.session.flash = { err: "Article couldn't be found" };
          return next();
        }
        
        var file = article.file;       
        var pdfPath = "/tmp/article.pdf";
        var opts = {
                     cssPath: '/linker/styles/bootstrap.css'
                   };
      
        Article.convert(file, pdfPath, opts, function() {
          res.download(pdfPath)
        });
  
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
    // Warning: destroys all current
    // records
    populate: function(req, res) {
      Article.destroy({})
      .then(function() {
        Article.list(appConfig.submodulePath, function(err, articles) {
          articles.files.forEach(function(file) {
            
            // Issues with unique not registering
            // on slugs due to waterline 
            // need a workaround as
            // duplicate slugs exist
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