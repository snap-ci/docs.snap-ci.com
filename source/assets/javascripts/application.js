//= require includes/jquery-2.1.1
//= require includes/automatic-anchors
//= require includes/tracking
//= require includes/retina

$(function(){
  $('img').each(function(){
    var image = $(this);
    var width = parseFloat(image.attr('width')) || 0;
    if (width >= 900){
      image.addClass('needs-scaling');
    }
  });
});
