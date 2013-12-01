jQuery(function() {
  
  /// Fix for Bootstrap Modals not affecting dom layout but rendering underneath elemetns unclickable
  jQuery(document)
    .on('click', 'a[data-target="#myModal"], #myModal button.close, #myModal button[data-dismiss="modal"]', function() {
      $('#myModal').toggleClass('z-index-fix');
  })

  // Methods that replace word and character count
  var updateStatsPanel = function(content) {
    var holder = getWordsAndCharacters(content);
    jQuery('#word-count').text(" Word count " + holder[0]);
    jQuery('#character-count').text(" Character count " + holder[1]);
  };
  
  var getWordsAndCharacters = function(content) {
    var words = getWords(content), characters = getCharacters(content);
    if(characters===0){words=0;}
    return [words, characters]
  }
  
  var getWords = function(content) {
    return content.trim().replace(/\s+/gi, ' ').split(' ').length;
  }
  
  var getCharacters = function(content) {
    return content.length;
  }

  // // Update word and character count every time content is modified
  jQuery('.editable')
      .keydown(function(event, data) {
        updateStatsPanel(jQuery('.editable').text());
  });  
  
  var content = 
    jQuery('.editable').length > 0 ? 
    jQuery('.editable').text() : 
    jQuery('.not-editable').text();
    
  updateStatsPanel(content);
  
});
