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
    Article.read appConfig.submodule.path + req.param('file'), foundArticle = (err, article) ->
      res.view
        article: article

  'new': (req, res) ->
    res.view {}

  create: (req, res, next) ->
    Article.saveWithGit req.param("file"), req.param("content"), "Created", (err, article) ->
      flash.msg req, "success", "article", "was successfully created."
      res.redirect "/article"

  edit: (req, res) ->
    Article.read appConfig.submodule.path + req.param("file"), foundArticle = (err, article) ->
      res.view
        article: article

  update: (req, res) ->
    Article.saveWithGit req.param("file"), req.param("content"), "Updated", (err, article) ->
      req.session.flash = error: err  if err
      unless article
        flash.msg req, "error", "article", "could not be found."
      else
        flash.msg req, "success", "article", "was successfully updated."
      res.redirect "/article"

  destroy: (req, res) ->
    Article.destroyWithGit appConfig.submodule.path + req.param("file"), null, "Deleted", (err, article) ->
      if article
        flash.msg req, "error", "article", "could not be destroyed."
        res.redirect "/article"
      else
        flash.msg req, "success", "article", "was successfully destroyed."
      res.redirect "/article"
            
  convert: (req, res) ->
    Article.findOne req.param("id"), articleFound = (err, article) ->
      req.session.flash = error: err  if err
      unless article
        flash.msg req, "error", "article", "with the given information could not be found."
        return res.send 404, req.session.flash
      file = article.file
      pdfPath = "/tmp/article.pdf"
      opts = cssPath: "/linker/styles/bootstrap.css"
      Article.convert file, pdfPath, opts, ->
        res.download pdfPath
   
      
module.exports = ArticleController