/**
 * ArticleController
 *
 * @module		:: Controller
 * @description	:: Contains logic for handling requests.
 */

var ArticleController = {
    index: function(req, res) {
        // var fs = require('fs');
        // var file = fs.readFileSync('files/test.md');
        // res.view({ file: file });

        res.view({ file: req });
    },
    open: function(req, res) {
        var file = req.param('file');
        var fs = require('fs');
        fs.readFile('files/' + file, function(err, data){
            if (err) res.send("Couldn't open file: " + err.message);
            else res.send(data);
        });
    },
    save: function(req, res) {
        var file = req.param('file');
        var content = req.param('content');
        var fs = require('fs');
        fs.writeFile('files/' + file, content, function(err, data){
            if (err) res.send("Couldn't write file: " + err.message);
            else res.send("Success");
        });
    }
};

module.exports = ArticleController;