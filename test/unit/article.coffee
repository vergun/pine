ArticleFactory = require("./factories/article")

beforeEach (done) ->
  _.each Article.find(), (article) ->
    Article.destroy article
  done()

describe 'ArticleController', ->  

  describe 'Creating a new article', ->
        
    it 'should have a file attribute of type string', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert typeof article.file is "string"
        done()
        
    it 'should have a file attribute equal to the submodule path plus its file argument', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert ArticleFactory.submodulePath() + ArticleFactory.article().file is article.file
        done()   
        
    it 'should have a slug attribute of type string', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert typeof article.slug is "string"
        done()   
        
    it 'should have an id of type string', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert typeof article.id is "string"
        done()
        
    it 'should have an id that represents a valid BSON Object', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert /^[0-9a-fA-F]{24}$/.test(article.id) is true
        done()

    it 'should not have a _.csrf attribute', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert typeof article._csrf is "undefined"
        done()
        
    it 'should not have a createdAt attribute', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert typeof article.createdAt is "undefined"
        done()
        
    it 'should not have a updatedAt attribute', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert typeof article.updatedAt is "undefined"
        done()
        
    it 'should not support inserting an attribute other than "file"', (done) ->
      Article.create _.extend(ArticleFactory.article(), popcorn: "isGood", atThe: "movies"), (err, article) ->
        assert Object.keys(article).indexOf "popcorn"  is -1
        assert Object.keys(article).indexOf "atThe"    is -1
        done()
        
    it 'should replace a user provided slug argument with a server generated slug', (done) ->
      Article.create _.extend(ArticleFactory.article(), slug: "ziggyTheSlug"), (err, article) ->
        assert Object.keys(article).indexOf "slug" is 1
        assert article.slug isnt "ziggyTheSlug"
        done()
        
    it 'should create a slug regardless of whether a slug is provided', (done) ->
      article = ArticleFactory.article()
      delete article.slug
      Article.create article, (err, article) ->
        assert Object.keys(article).indexOf "slug" is 1
        done()
        
    it 'should have a lowercase slug with no spaces or punctuation', (done) ->
      Article.create ArticleFactory.article(), (err, article) ->
        assert article.slug.toLowerCase() is article.slug
        assert /\s/.test(article.slug) is false
        assert /[\.,\/#!$%\^&\*;:{}=\_`~()]/.test(article.slug) is false
        done()
        
  describe 'Creating two articles with identical paths', ->
      
    # Todo: Needs to be addressed
    it 'should not distinguish between identical slugs', (done) ->
      Article.create(ArticleFactory.article()).then (articleOne) ->
        Article.create(ArticleFactory.article()).then (articleTwo) ->
          assert articleOne.slug is articleTwo.slug
          done()

