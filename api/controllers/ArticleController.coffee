###
ArticleController

@module    	  :: Controller
@description	:: Contains logic for handling requests.
###

fs              = require 'fs'
path            = require 'path'
flash           = require '../services/flashHelper'

ArticleController =
  
  index: (req, res) ->
    Article.list appConfig.submodule.path, foundArticles = (articles) ->
      res.view articles: articles
      
  show: (req, res, next) ->
    Article.read req.param("path"), foundArticle = (err, article) ->  
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
      
  fetch: (req, res) ->
    Article.list req.param("path"), foundArticles = (articles) ->
      res.json
        success: true,
        user: req.session.User,
        articles: articles
        
  publish: (req, res) ->
    Article.buildForWintersmith req, req.param("path"), (err, success) -> 
      flash.msg req, "success", "article", "was successfully published."
      res.redirect "/article"
    
  copy: (req, res) ->
    ArticleHelper.copy req.params("path"), req.params("destination"), () ->
      res.json
        success:true
    
  move: (req, res) ->
    ArticleHelper.move req.params("path"), req.params("destination"), () ->
      res.json
        success:true
      
  sendFile: (req, res) ->
    res.download req.param("file"), (err) ->
      if err
        log.info err #todo over sockets send response
      
  subscribe: (req, res) ->
    Article.subscribe req.socket
    res.send 200
      
module.exports = ArticleController