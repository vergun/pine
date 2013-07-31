MainController = 
    index: (req, res) ->
        git = require 'gift'
        repo = git '../Pinecones'
        stat = repo.status (err, status) ->
            console.log status 

        res.view { file: req }

    open: (req, res) ->
        file = req.param 'file'
        fs = require 'fs'
        fs.readFile 'files/' + file, (err, data) ->
            if err
                res.send "Couldn't open file: " + err.message
            else 
                res.send data

    save: (req, res) ->
        file = req.param 'file'
        content = req.param 'content'
        fs = require 'fs'
        fs.writeFile 'files/' + file, content, (err, data) ->
            if err
                res.send "Couldn't write file: " + err.message
            else 
                res.send "Success"


module.exports = MainController