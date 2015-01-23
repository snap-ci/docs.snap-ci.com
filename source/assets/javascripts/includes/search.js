$(function() {
  var template = '';
  template += '<form class="search-form">';
  template += '  <input type="text" id="st-search-input" class="st-search-input" />';
  template += '</form>';

  $('.header-actions').append($(template));

  // this is the code from swiftype
  (function(w, d, t, u, n, s, e) {
    w['SwiftypeObject'] = n;
    w[n] = w[n] || function() {
      (w[n].q = w[n].q || []).push(arguments);
    };
    s = d.createElement(t);
    e = d.getElementsByTagName(t)[0];
    s.async = 1;
    s.src = u;
    e.parentNode.insertBefore(s, e);
  })(window, document, 'script', '//s.swiftypecdn.com/install/v1/st.js', '_st');

  _st('install', 'PPBfRD6R9W5gWXCnyT9j');
});
