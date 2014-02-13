/// Template settings mustache {{ }}


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
  
  this.el = $(el)
  this.rowsTemplate = $('#rows-template').html()
    
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

  this.showNewFilesAndFolders = function(_el, response) {
    var _this = this;
    response.articles.children.forEach(function(child, index) {
      
      var template = _.template(
        _this.rowsTemplate, { child: child, response: response }
      );
      
      $(_el).after(template);
      
    })
  }

}

/// ImplementationDetails
$(document).on('click', 'ul.article-list li.folder', function() {
  
  _.templateSettings = {
    evaluate    : /\{\{([\s\S]+?)\}\}/g,
    interpolate : /\{\{=([\s\S]+?)\}\}/g,
    escape      : /\{\{-([\s\S]+?)\}\}/g
  };
    
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

