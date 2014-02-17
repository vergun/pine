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
jQuery(document)
  .on('click', 'ul.article-list li.folder', function() {
  
  /// Template settings mustache {{ }}
  _.templateSettings = {
    evaluate    : /\{\{([\s\S]+?)\}\}/g,
    interpolate : /\{\{=([\s\S]+?)\}\}/g,
    escape      : /\{\{-([\s\S]+?)\}\}/g
  };
    
  runClickedFolder(this);
})

/// Fix for Bootstrap Modals not affecting dom layout but rendering underneath elemetns unclickable
// copy
jQuery(document)
  .on('click', 'a[data-target="#copyArticle"], #copyArticle button.close, #copyArticle button[data-dismiss="modal"]', function() {
    $('#copyArticle').toggleClass('z-index-fix');
})

// move
jQuery(document)
  .on('click', 'a[data-target="#moveArticle"], #moveArticle button.close, #moveArticle button[data-dismiss="modal"]', function() {
    $('#moveArticle').toggleClass('z-index-fix');
})

// copy
jQuery(document)
.on('click', 'a[data-target="#copyArticle"]', function() {
  var path = $(this).parents('li').data('path')
  $('input#copyArticleSource').attr("placeholder", path);  
  $('input#copyArticleSource').val(path);
})

// move
jQuery(document)
.on('click', 'a[data-target="#moveArticle"]', function() {
  var path = $(this).parents('li').data('path')
  $('input#moveArticleSource').attr("placeholder", path); 
  $('input#moveArticleSource').val(path);  
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

