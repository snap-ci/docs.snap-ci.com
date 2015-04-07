$(function () {
  var generateUUID = function() {
    var d = new Date().getTime();
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = (d + Math.random()*16)%16 | 0;
      d = Math.floor(d/16);
      return (c=='x' ? r : (r&0x3|0x8)).toString(16);
    });
    return uuid;
  };

  var cname = function (current) {
    var name = current.text();
    return name.toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g, '').replace(/[\?\.\!\'\"\(\)]/g, '');
  };

  var warn = function (message) {
    console.log(message);
    if ($('meta[development=true]').length > 0) {
      alert(message);
    }
  };

  var createAnchorLink = function (id, content, attrs) {
    attrs = attrs || {};
    var elem = $('<a>');
    var newAttrs = $.extend({}, attrs, {href: '#' + encodeURIComponent(id)});
    return elem.attr(newAttrs).html(content);
  };

  var createAnchorOn = function (elem, id) {
    if ($('#' + id).length > 0) {
      warn("Found more than 1 elements matching $('#" + id + "')");
    }

    elem.attr("id", id);
    elem.attr('data-toc-uuid', generateUUID());
    elem.attr('has-anchor', true);

    var anchorLink = createAnchorLink(id, '#', {class: 'toc-anchor'}); //$('<a class=\"toc-anchor\" href=\"#' + encodeURIComponent(id) + '\">#</a>');
    anchorLink.hide();

    elem.on('mouseenter', function () {
      elem.append(anchorLink);
      anchorLink.show();
    });

    elem.on('mouseleave', function () {
      anchorLink.remove();
      anchorLink.hide();
    })
  };

  var tocElem = null;

  function createList() {
    return $('<ul>');
  }

  if ($('.api').length > 0) {
    var tocContainer = $('<div>').attr({id: 'toc'});
    tocElem = createList();
    tocContainer.append(tocElem);
    $('.doc-content').prepend(tocContainer);
  }

  var createTocElem = function (tocElem, linkToElem, id) {
    if (!tocElem){
      return;
    }
    var newListItem = $('<li>').attr('data-toc-for', linkToElem.data('toc-uuid'));
    newListItem.append($('<a>').attr({href: '#' + encodeURIComponent(id)}).html(linkToElem.html()));
    tocElem.append(newListItem);
  };

  // do not setup h1, h2 here because nested links are not handled properly.
  // For e.g. if you have <h2>Version</h2> under two different <h1> tags
  $('.doc-content').children("h1").each(function () {
    var current = $(this);
    var id = cname(current);

    createAnchorOn(current, id);
    createTocElem(tocElem, current, id);
  });

  $('.doc-content').children('h2').each(function () {
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
