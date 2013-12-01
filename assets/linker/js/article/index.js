/// jquery implementation
$(document).on('click', 'ul.article-list li.folder', function() {
  runClickedFolder(this);
})

var runClickedFolder = function(el) {
  slideToggle(el);
  swapExpandCollapseIcon(el);
}

var slideToggle = function(el) {
  $(el).parent().children('ul').toggle('fast');
}

var swapExpandCollapseIcon = function(el) {
  element = $(el).find('i.switch')
  if (element.hasClass('icon-collapse-alt switch')) {
    element.attr('class', 'icon-expand-alt switch')
  } else {
    element.attr('class', 'icon-collapse-alt switch')
  }
}