jQuery(function() {
  
  // Submit form when clicking save link
  jQuery(document).on('click', '#edit-article-save', function() {
    var form = jQuery('#save-article-form');
    $.ajax({
      type: form.attr('method'),
      url: form.attr('action'),
      dataType: 'json',
      data: form.serialize()
    })
  })
  
});
