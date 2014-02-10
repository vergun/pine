/// Submit Socket Request
function RequestManager(el) {
  this.path = $(el).data('path');
  
  this.dispatch = function(callback) {
    socket.get('/article/fetch', {
      path: this.path
    }, function(response) {
      if (callback && typeof callback == "function") {
        var _el = el;
        callback(_el, response);
      }   
    })
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
  
  this.showNewFolders = function(_el, response) {
    response.articles.children.forEach(function(child, index) {
      if (child.type == "folder" || child.name.indexOf(".md") != -1) {
        $(_el).after('<ul class="article-list" style="display: block;"><li class="' + child.type + '" data-path="' + child.path + '" data-has-been-opened="' + 'false' + '">' + 
        '<i class="icon-expand-alt switch"></i><i class="icon-folder-close"></i> ' + child.name +
        ' </li></ul' )
      }
    })
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
    request.dispatch(function(_el, response) {
      directoryManager.showNewFolders(_el, response);
    });
  }
  
  directoryManager.slideToggle();
  directoryManager.swapExpandCollapseIcon();
  directoryManager.setHasBeenOpenedDataAttribute();

}

