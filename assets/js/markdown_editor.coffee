$(document).ready ->
    marked.setOptions
        gfm: true
        tables: true
        breaks: false
        pedantic: false
        sanitize: false
        smartLists: true
        smartypants: false
        langPrefix: 'language-'
        highlight: (code, lang) ->
            if lang == 'js'
                return highlighter.javascript code
            return code
    
    class Editor 
        constructor: (input, preview) ->
            this.update = ->
                preview.innerHTML = marked input.value
            input.editor = this
            this.update

    $_ = (id) -> 
        document.getElementById id

    new Editor $_('editor'), $_('preview')


    $('#open_file_action').click ->
        file = $_('open_file_name').value
        $.post '/open', {file: file},
            (resp) ->
                $_('editor').value = resp
                $_('preview').innerHTML = marked resp
                $_('save_file_name').value = file
                $('#open_dialog').modal 'toggle'
                return

    $('#save_file_action').click ->
        file = $_('save_file_name').value
        content = $_('editor').value
        $.post '/save', {file: file, content: content},
            (resp) ->
                console.log "Saved!"
                console.log resp
                $('#save_dialog').modal 'toggle'
                return

    return