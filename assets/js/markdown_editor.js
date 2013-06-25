$(document).ready(function(){
    // Set default options
    marked.setOptions({
        gfm: true,
        tables: true,
        breaks: false,
        pedantic: false,
        sanitize: false,
        smartLists: true,
        smartypants: false,
        langPrefix: 'language-',
        highlight: function(code, lang) {
            if (lang === 'js') {
                return highlighter.javascript(code);
            }
            return code;
        }
    });
    
    function Editor(input, preview) {
        this.update = function() {
            preview.innerHTML = marked(input.value);
        };
        input.editor = this;
        this.update();
    }
    var $_ = function(id) { return document.getElementById(id); };
    new Editor($_('editor'), $_('preview'));


    $('#open_file_action').click(function(){
        var file = $_('open_file_name').value;
        $.post(
            '/open',
            {file: file},
            function(resp) {
                $_('editor').value = resp;
                $_('preview').innerHTML = marked(resp);
                $_('save_file_name').value = file;
                $('#open_dialog').modal('toggle');
            }
        );
    });
    $('#save_file_action').click(function(){
        var file = $_('save_file_name').value;
        var content = $_('editor').value;
        $.post(
            '/save',
            {file: file, content: content},
            function(resp) {
                console.log("Saved!");
                console.log(resp);
                $('#save_dialog').modal('toggle');
            }
        );
    });
});