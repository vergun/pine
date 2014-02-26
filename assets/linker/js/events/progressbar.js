jQuery(document)
    .ready(function() {
                  
      // Create SocketIO instance, connect
      var showProgressBar;
      var incrementProgressBar;
      
      //subscribe to the article model
      socket.get('/article/subscribe', function(response){})
      
      //event triggered on publish
      socket.on('message', function(data) {
        if (data["type"] == "progress-bar") {
          showProgressBar();
          incrementProgressBar(data);
          changeProgressBarMessage(data);
        }
      })
      //show the progress bar and overlay
      showProgressBar = function() {
        var progressBar = $('.github-progress');
        var progressBarMessage = $('.progress-bar-message');
        var cover = $('.github-cover');
        if ( $('.github-progress').is(":hidden")) {
          cover.show();
          progressBar.fadeIn('400');
          progressBarMessage.fadeIn('400');
        }
      }
      //increment the progress bar
      incrementProgressBar = function(data) {
        var bar = $('.bar')
        var width = bar.css('width')
        var newWidth = (parseInt(width) + parseInt(data.amount)) + "%"
        bar.css('width', newWidth)
        if (parseInt(newWidth) >= 120) {
          progressComplete();
          setTimeout(navigateToNext, 2500)
        }
      }
      
      changeProgressBarMessage = function(data) {
        var selector = $('.progress-bar-message');
        selector.text(data["method"] + ": " + data["message"])
      }
      
      progressComplete = function() {
        var selector = $('.progress-bar-message');
        selector.fadeOut('fast', function() {
          selector.css('color', '#90EE90')
          selector.html('<i class="icon-check"></i> Complete')
          selector.fadeIn('400');
        })
      }
      
      //navigate to destination
      navigateToNext = function() {
        window.location.href = "/";
      }
      
});