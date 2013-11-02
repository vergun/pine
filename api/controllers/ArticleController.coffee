###
ArticleController

@module    	  :: Controller
@description	:: Contains logic for handling requests.
###

fs              = require 'fs'
path            = require 'path'
flash           = require '../services/flashHelper'
PopulateHelper  = require '../services/populateHelper'

ArticleController =
  
  index: (req, res) ->
    Article.find foundArticles = (err, articles) ->
      return next(err)  if err
      res.view articles: articles

  show: (req, res, next) ->
    Article.findOne req.param('id'), articleFound = (err, article) ->
      return next(err)  if err
      unless article
        flash.msg req, "error", "article", "with the given information could not be found."
        return next()
      breadcrumbs = path.normalize(article.file).split(path.sep)
      content = fs.readFileSync(article.file)
      res.view
        article: article
        content: content
        breadcrumbs: breadcrumbs

  'new': (req, res) ->
    res.view {}

  create: (req, res, next) ->
    file = "Pine_Needles/contents/articles//01_Get_Started/01_End_Users/01_Free_Trial/03_Discover_Sugar/index.md"
    req.body.file = file
    Article.create req.body, articleCreated = (err, article) ->    
      if err
        req.session.flash = error: err
        return res.redirect("/article/new")
      res.redirect "/article/" + article.slug

  edit: (req, res) ->
    Article.findOne req.param("id"), articleFound = (err, article) ->
      return next(err)  if err
      unless article
        flash.msg req, "error", "article", "with the given information could not be found."
        return next()
      content = fs.readFileSync(article.file)
      res.view
        article: article
        content: content

  update: (req, res) ->
    Article.saveWithGit req.param("file"), req.param("content"), "Updated", (err, article) ->
      req.session.flash = error: err  if err
      unless article
        flash.msg req, "error", "article", "could not be found."
      else
        flash.msg req, "success", "article", "was successfully updated."
      res.redirect "/article"

  destroy: (req, res) ->
    Article.findOne req.param("id"), articleFound = (err, article) ->
      Article.destroyWithGit article.file, null, "Deleted", (err, article) ->
        req.session.flash = error: err  if err
        if article
          flash.msg req, "error", "article", "could not be destroyed."
          res.redirect "/article"
        else
          flash.msg req, "success", "article", "was successfully destroyed."
          Article.destroy req.param("id"), destroyedArticle = (err, article) ->
            if err
              res.redirect "/article"
            else
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
        
  populate: (req, res, next) ->
    PopulateHelper.populateArticles (articles) ->
      res.send ok: articles
   
      
module.exports = ArticleController