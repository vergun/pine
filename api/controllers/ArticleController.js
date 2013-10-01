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
          
          var noArticleFound = [{name: 'noArticleFound', message: "An article with the given information could not be found."}]
   
          req.session.flash = {
            error: noArticleFound
          }  
          
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
          req.session.flash = { error: err }
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
          var noArticleFound = [{name: 'noArticleFound', message: "An article with the given information could not be found."}]
   
          req.session.flash = {
            error: noArticleFound
          }  
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
        
        // error on save
        if (err)  {
          req.session.flash = { error: err }
        }
        
        // article not found
        if (!article) {
          
          var articleNotFound = [{name: 'articleNotFound', message: "Article could not be found."}]
    
          req.session.flash = {
            error: articleNotFound
          }
                    
        }
        
        // article was updated
        else {
          
          var articleUpdated = [{name: 'articleUpdated', message: "Article was successfully updated."}]
          
          req.session.flash = {
            success: articleUpdated
          }
        }
 
        
        res.redirect('/article');
      })
    },
    
    destroy: function(req, res) {
      
      var articleDestroyed = [{name: 'articleDestroyed', message: "Article was destroyed."}]
    
      req.session.flash = {
        error: articleDestroyed
      }
      
      res.redirect('/article')
      
    },
    
    // Article :: convert
    // Turns parsed markdown
    // into downloadable pdf
    convert: function(req, res) {
      
      Article.findOne(req.param('id'), function articleFound (err, article) {
      
        if (err) req.session.flash = { error: err };
        
        if (!article) {
          
          var noArticleFound = [{name: 'noArticleFound', message: "An article with the given information could not be found."}]
   
          req.session.flash = {
            error: noArticleFound
          }  
          res.send(404, req.session.flash)
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
    
    // Task that seeds db articles from
    // Pine_Needles branch into mongo
    // Warning: destroys all current
    // records
    // todo: move to tasks service
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