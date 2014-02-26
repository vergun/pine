tinymce.init({
    selector: "div.editable",
    theme: "modern",
    plugins: [
        ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker"],
        ["searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking"],
        ["save table contextmenu directionality emoticons template paste"]
    ],
    add_unload_trigger: false,
    schema: "html5",
    inline: true,
    toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image     | print preview media",
    statusbar: false
});

// Todo implemenet:
// Update HTML every time content is modified
jQuery(document)
    .ready(function() {
      
var showSource = function(content) {
    jQuery('#source')
        .get(0)
        .value = content;
};

// update source code when typing
jQuery('div.editable')
    .bind('keypress', function() {
    var html = $('.editable').html();
    showSource(html);
});

// update source code when clicking editor
jQuery(document)
    .on('click', '.mce-btn, a[data-target="#myModal"]', function() {
    var html = $('.editable').html();
    showSource(html);
});

var html = 
  jQuery('div.editable').length > 0 ? 
  jQuery('div.editable').html() : 
  jQuery('div.not-editable').html();
  
showSource(html);

});