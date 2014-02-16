tinymce.init({
    selector: "div.editable",
    theme: "modern",
    plugins: [
        ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker"],
        ["searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking"],
        ["save table contextmenu directionality emoticons template paste style"]
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

jQuery('.editable')
    .bind('hallomodified', function(event, data) {
    showSource(data.content);
});

var html = 
  jQuery('.editable').length > 0 ? 
  jQuery('.editable').html() : 
  jQuery('.not-editable').html();
  
showSource(html);

});