$(function(){
  var cname = function(current) {
    var name = current.text();
    return name.replace(/[ \/<>]/g, '-').replace(/:$/, '');
  }

  // do not setup h1, h2 here because nested links are not handled properly.
  // For e.g. if you have <h2>Version</h2> under two different <h1> tags
  $('.doc-content').children("h1").each(function(i) {
    var current = $(this);
    console.log($(this));

    var id = cname(current);
    current.attr("id", id);
    current.append(' <a class=\"toc-anchor\" href=\"#' + encodeURIComponent(id) + '\">#</a>');
  });
});
