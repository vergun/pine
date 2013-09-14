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
    show: function(req, res) {
      // var fs = require('fs');
      // var file = fs.readFileSync('files/test.md');
    }
};

module.exports = ArticleController;