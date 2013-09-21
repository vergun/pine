(function(jQuery) {
  
  jQuery(document).ready(function() {
    
    jQuery('.editable').hallo({
      plugins: {
        'halloformat': {},
        'halloheadings': {},
        'hallojustify': {},
        'hallolists': {},
        'halloreundo': {},
        'hallolink': {},
        'halloimage': {}
      }
    });
    
  });
  
})(jQuery)