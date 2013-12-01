/// Fix for Bootstrap Modals not affecting dom layout but rendering underneath elemetns unclickable
$(document).on('click', 'a[data-target="#myModal"], #myModal button.close, #myModal button[data-dismiss="modal"]', function() {
  $('#myModal').toggleClass('z-index-fix');
});