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
  
  // Add new metadata
  jQuery(document).on('click', '#add-new-metadata', function() {
    headersDiv = $('.article-headers')
    headersDiv.after(
    '<input type="text" class="new-attribute-label" placeholder="name"><input type="text" form="save-article-form" placeholder="value" contenteditable=true>'
    )
  })
  
  // Assign label field value to attribute name
  jQuery(document).on('keyup', '.new-attribute-label', function() {
    label = $(this)
    label.next('input').attr( 'name', label.val() )
  })
  
});
