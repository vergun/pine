/// Fix for Bootstrap Modals not affecting dom layout but rendering underneath elemetns unclickable
$(document).on('click', 'a[data-target="#myModal"]', function() {
  $('#myModal').toggleClass('z-index-fix');
});
