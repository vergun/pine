###
ArticleController

@module    	  :: Controller
@description	:: Contains logic for handling requests.
###

fs              = require 'fs'
path            = require 'path'
flash           = require '../services/flashHelper'

ArticleController =
    
  listBuckets: (req, res) ->
    Article.listBuckets req, () ->
      log.info "Finished listing buckets."
  
  index: (req, res) ->
    Article.list appConfig.submodule.path, foundArticles = (articles) ->
      res.view articles: articles
      
  show: (req, res, next) ->
    Article.read req.param("path"), foundArticle = (err, article) ->   
      ArticleHelper.readCommits article, (err, article) -> 
        ArticleHelper.readHeaders article, (err, article) ->
          res.view
            article: article

  'new': (req, res) ->
    res.view {}

  create: (req, res, next) ->
    Article.saveWithGit req, req.param("path"), req.param("content"), "Created", (err, article) ->
      Article.buildForWintersmith req, req.param("path"), (err, success) -> 
        flash.msg req, "success", "article", "was successfully created."
        res.redirect "/article"

  edit: (req, res) ->
    Article.read req.param("path"), foundArticle = (err, article) ->
      ArticleHelper.readCommits article, (err, article) -> 
        ArticleHelper.readHeaders article, (err, article) ->
          res.view
            article: article
            edit: true

  update: (req, res) ->
    ArticleHelper.setHeaders req, (err, req) ->
      Article.saveWithGit req, req.param("path"), req.param("content"), "Updated", (err, article) ->
        Article.buildForWintersmith req, req.param("path"), (err, success) -> 
          req.session.flash = error: err if err
    
          unless article
            flash.msg req, "error", "article", "could not be found."
          else
            flash.msg req, "success", "article", "was successfully updated."
          res.redirect "/article"

  destroy: (req, res) ->
    Article.destroyWithGit req, appConfig.submodule.path + req.param("file"), null, "Deleted", (err, article) ->
      if article
        flash.msg req, "error", "article", "could not be destroyed."
        res.redirect "/article"
      else
        flash.msg req, "success", "article", "was successfully destroyed."
      res.redirect "/article"
      
  getDiff: (req, res) ->
    ArticleHelper.getDiff req.param("commit"), req.param("path"), (err, article) -> 
      res.json
        success: true,
        diff: article.diff
      
  fetch: (req, res) ->
    Article.list req.param("path"), foundArticles = (articles) ->
      res.json
        success: true,
        user: req.session.User,
        articles: articles
        
  publish: (req, res) ->
    Article.buildForWintersmith req, req.param("path"), (err, success) -> 
      Article.putS3 req, req.param("path"), () ->
        log.info "Put #{req.param('path')} to S3."
        flash.msg req, "success", "article", "was successfully published."
        res.redirect "/article"
    
  copy: (req, res) ->
    #todo use github helper saveWithGit method only
    ArticleHelper.copy req.param("path"), req.param("destination"), () ->
      fs.readFile req.param("path"), (err, fileContent) ->
        Article.saveWithGit req, req.param("destination"), fileContent, "Copied", () ->   
          flash.msg req, "success", "article", "was successfully created."
          res.redirect "/article"
    
  move: (req, res) ->
    #todo use github helper saveWithGit method only
    ArticleHelper.move req.param("path"), req.param("destination"), () ->
      Article.destroyWithGit req, req.param("path"), null, "Deleted", () ->
        fs.readFileSync req.param("path"), (err, fileContent) ->     
          Article.saveWithGit req, req.param("destination"), fileContent, "Moved", () ->
            flash.msg req, "success", "article", "was successfully created."
            res.redirect "/article"
      
  sendFile: (req, res) ->
    res.download req.param("file"), (err) ->
      if err
        log.error err #todo over sockets send response
      
  subscribe: (req, res) ->
    Article.subscribe req.socket
    res.send 200
      
module.exports = ArticleController