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
        var progressBar = $('.github-progress')
        var cover = $('.github-cover')
        if ( $('.github-progress').is(":hidden")) {
          cover.show();
          progressBar.fadeIn('400')
        }
      }
      //increment the progress bar
      incrementProgressBar = function(data) {
        var bar = $('.bar')
        var width = bar.css('width')
        var newWidth = (parseInt(width) + parseInt(data.amount)) + "%"
        bar.css('width', newWidth)
      }
      
      changeProgressBarMessage = function(data) {
        var selector = $('.progress span')
        selector.text(data["method"] + ": " + data["message"])
      }
   
});