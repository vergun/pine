// Modified from http://hallojs.org/demo/markdown/

jQuery(document)
    .ready(function() {
    // Enable Hallo editor
    jQuery('.editable')
        .hallo({
        plugins: {
            'halloformat': {},
            'halloheadings': {},
            'hallolists': {},
            'halloreundo': {}
        },
        toolbar: 'halloToolbarFixed'
    });

    // Method that converts the HTML contents to Markdown
    var showSource = function(content) {
        if (jQuery('#source')
            .get(0)
            .value == content) {
            return;
        }
        jQuery('#source')
            .get(0)
            .value = content;
    };

    // Update HTML every time content is modified
    jQuery('.editable')
        .bind('hallomodified', function(event, data) {
        showSource(data.content);
    });
    showSource(jQuery('.editable')
        .html());
});