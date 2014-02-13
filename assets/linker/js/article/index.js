/// Provide notification to the user
function NotificationManager() {
  this.flash = $('.attention');
  
  this.show = function() {
    this.flash.show();
  }
  
  this.hide = function() {
    this.flash.hide();
  }
}

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

  /* todo remove data-has-been-opened from files to avoid network requests */
  this.showNewFilesAndFolders = function(_el, response) {
    response.articles.children.forEach(function(child, index) {
      
      if (child.type == "folder" || child.name.indexOf(".md") != -1) {
        
        var string = '<ul class="article-list" style="display: block;"><li class="' + child.type + '" data-path="' + child.path + '" data-has-been-opened="' + 'false' + '">';
        
        if (child.type == "folder") { string+='<i class="icon-expand-alt switch"></i><i class="icon-folder-close"></i>' }
        if (child.type == "file")   { string+= '<i class="icon-file"></i>' }
        
        string+= child.name + '<span class="article-buttons"><a href="/article/show?path=' + child.path + '" class="btn btn-mini btn-primary">Show</a>'
      
        if (response.user && typeof response.user != "undefined") {
          string+= '<a href="/article/edit?path=' + child.path + '" class="btn btn-mini btn-warning">Edit</a>';
          string+= '<a href="/article/destroy?path=' + child.path + '" class="btn btn-mini btn-danger">Destroy</a>';
        }

        string += '</li></ul'
        
        $(_el).after(string);
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
    var notificationManager = new NotificationManager();
    notificationManager.show();
    
    var request = new RequestManager(el);
    request.dispatch(function(_el, response) {
      notificationManager.hide();
      directoryManager.showNewFilesAndFolders(_el, response);
    });
  }
  
  directoryManager.slideToggle();
  directoryManager.swapExpandCollapseIcon();
  directoryManager.setHasBeenOpenedDataAttribute();

}

