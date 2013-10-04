#---------------------------------------------------------------
#  :: sails-github
#  -> adapter
#---------------------------------------------------------------

fs = require("fs")
markdownpdf = require("markdown-pdf")
pdfHelper = require("../services/pdfHelper")

module.exports = (->
  
  adapter =
    syncable: false
    defaults: {}
    registerCollection: (collectionName, cb) ->
      self = this
      cb()

    teardown: (cb) ->
      cb()  if cb

    save: (collectionName, file, content, next) ->
      # explicitly declare args
      # write the file to the filesystem
      # send proper error response if an error
      # otherwise update GitHub
      # and send ok response
      # run post-receive.sh from bash
      afterSave = ->
        spawn = require("child_process").spawn
        postReceive = spawn("sh", ["post-receive.sh"],
          cwd: process.cwd()
          env: _.extend(process.env,
            PATH: process.env.PATH + ":/usr/local/bin"
          )
        )
      file = file
      content = content
      fs.writeFile appConfig.submodulePath + file, content, (err, data) ->
        if err
          res.send error:
            message: "Couldn't write file."


      afterSave()
      next.send ok:
        message: "File written."


    refresh: (collectionName, file, content, next) ->
      # explicitly declare args
      # write the file to the filesystem
      # send proper error response if an error
      # update GitHub
      # proceed to controller
      # run post-receive.sh from bash
      afterSave = ->
        spawn = require("child_process").spawn
        postReceive = spawn("sh", ["post-receive.sh"],
          cwd: process.cwd()
          env: _.extend(process.env,
            PATH: process.env.PATH + ":/usr/local/bin"
          )
        )
      file = file
      content = content
      fs.writeFile file, content, (err, data) ->
        if err
          return res.send(error: [
            name: "fileWriteError"
            message: "Couldn't write file."
          ])
        afterSave()
        next err,
          file: file
          content: content

    convert: (collectionName, file, pdfPath, opts, next) ->
      file = file
      pdfPath = pdfPath
      opts = opts
      pdfHelper.convert file, opts, pdfPath, next

    list: (collectionName, path, next) ->
      walk = (dir, done) ->
        results = []
        fs.readdir dir, (err, list) ->
          return done(err)  if err
          i = 0
          (next = ->
            file = list[i++]
            return done(null, results)  unless file
            file = dir + "/" + file
            fs.stat file, (err, stat) ->
              if stat and stat.isDirectory()
                walk file, (err, res) ->
                  results = results.concat(res)
                  next()

              else
                isItMarkdown = /\.[md]+$/i
                results.push file  if isItMarkdown.test(file)
                next()

          )()

      walk path, (err, files) ->
        next err,
          files: files

  adapter
)()