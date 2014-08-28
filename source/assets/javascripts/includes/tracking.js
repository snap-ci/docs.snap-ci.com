if (window.location.href.indexOf('//docs.snap-ci.com') !== -1) {
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-43024613-2']);
  _gaq.push(['_setDomainName', 'snap-ci.com']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script');
    ga.type = 'text/javascript';
    ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(ga, s);
  })();
}

if (window.location.href.indexOf('//docs.snap-ci.com') !== -1) {
  (function() {
    var didInit = false;

    function initMunchkin() {
      if (didInit === false) {
        didInit = true;
        Munchkin.init('199-QDE-291');
      }
    }
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.async = true;
    s.src = '//munchkin.marketo.net/munchkin.js';
    s.onreadystatechange = function() {
      if (this.readyState == 'complete' || this.readyState == 'loaded') {
        initMunchkin();
      }
    };
    s.onload = initMunchkin;
    document.getElementsByTagName('head')[0].appendChild(s);
  })();
}
