// Modified from http://hallojs.org/demo/markdown/

jQuery(document)
    .ready(function() {
    // Enable Hallo editor
    jQuery('.editable')
        .hallo({
        plugins: {
            'halloformat': {},
            'halloheadings': {},
            'hallojustify': {},
            'hallolists': {},
            'halloreundo': {},
            'halloimage': {}
        },
        toolbar: 'halloToolbarFixed'
    });

    // Method that converts the HTML contents to Markdown
    var showSource = function(content) {
        jQuery('#source')
            .get(0)
            .value = content;
    };

    // Update HTML every time content is modified
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