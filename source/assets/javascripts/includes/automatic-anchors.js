$(function(){
  var cname = function(current) {
    var name = current.text();
    return name.toLowerCase().replace(/[ \/<>]/g, '-').replace(/:$/, '').replace(/\?/, '').replace(/\./, '').replace(/'/, '');
  }

   var warn = function (message){
    console.log(message);
    if ($('meta[development=true]').length > 0){
      alert(message);
    }
  }

  var createAnchorOn = function(elem, id){
    if ($('#' + id).length > 0){
      warn("Found more than 1 elements matching $('#" + id + "')");
    }

    elem.attr("id", id);
    elem.attr('has-anchor', true);

    var anchorLink = $('<a class=\"toc-anchor\" href=\"#' + encodeURIComponent(id) + '\">#</a>');
    anchorLink.hide();
    elem.append(anchorLink);

    elem.on('mouseenter', function(){
      anchorLink.show();
    });

    elem.on('mouseleave', function(){
      anchorLink.hide();
    })
  }

  // do not setup h1, h2 here because nested links are not handled properly.
  // For e.g. if you have <h2>Version</h2> under two different <h1> tags
  $('.doc-content').children("h1").each(function() {
    var current = $(this);
    createAnchorOn(current, cname(current));
  });

  $('.doc-content').children('h2').each(function(){
    var current = $(this);
    var parentHeading = current.prevAll('h1[has-anchor]:first');
    if (parentHeading.length === 0) {
      var subHeadingId = cname(current);
      createAnchorOn(current, subHeadingId);
    } else {
      var subHeadingId = parentHeading.attr('id') + '#' + cname(current);
      createAnchorOn(current, subHeadingId);
    }
  });
});
