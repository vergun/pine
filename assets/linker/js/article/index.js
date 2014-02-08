/// Submit Socket Request
function RequestManager(el) {
  this.path = $(el).data('path');
  
  this.dispatch = function() {
    //Send socket request
  } 
}


/// Manage Directory Tree Structure
function DirectoryManager(el) {
  
  this.el = $(el);
    
  this.setHasBeenOpenedDataAttribute = function() {
    this.el.data('has-been-opened', 'true');
  }
  
  this.slideToggle = function(){
    this.el.parent().children('ul').toggle('fast');
  }
  
  this.swapExpandCollapseIcon = function() {
    var element = this.el.find('i.switch');
    if (element.hasClass('icon-collapse-alt switch')) {
      element.attr('class', 'icon-expand-alt switch')
    } else {
      element.attr('class', 'icon-collapse-alt switch')
    }
  }
  
  this.opened = function() {
    return this.el.data('has-been-opened')
  }
  
}

/// ImplementationDetails
$(document).on('click', 'ul.article-list li.folder', function() {
  runClickedFolder(this);
})

var runClickedFolder = function(el) {
  
  var directoryManager = new DirectoryManager(el);
  
  if (!directoryManager.opened()) {
    var request = new RequestManager(el);
    request.dispatch();
  }
  
  directoryManager.slideToggle();
  directoryManager.swapExpandCollapseIcon();
  directoryManager.setHasBeenOpenedDataAttribute();

}

