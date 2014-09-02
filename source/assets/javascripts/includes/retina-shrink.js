$(function(){
  $('img').each(function(){
    var image = $(this);
    var width = parseFloat(image.attr('width')) || 0;
    if (width >= 900){
      image.addClass('needs-scaling');
    }
  });
});
