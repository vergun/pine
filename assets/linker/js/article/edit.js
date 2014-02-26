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
  
  // Git diff
  jQuery(document)
    .on('click', 'a[data-target="#commit"], #commit button.close, #commit button[data-dismiss="modal"]', function() {
      $('#commit').toggleClass('z-index-fix');
  })
  
  // Send socket request
  jQuery(document).on('click', 'a[data-target="#commit"]', function() {
    var commitHash = $(this).data('commit');
    var path       = $(this).data('path');
    socket.get('/article/getDiff', {
      commit: commitHash,
      path:   path
    }, function(response) {
      
      $('#commit .modal-body').text(response.diff);
      
    })  
  });
  
});
