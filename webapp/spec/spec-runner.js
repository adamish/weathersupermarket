requirejs.config({
  baseUrl : 'js'
});
require([ 'config' ], function() {

  requirejs.config({
    paths : {
      jasmine : '../jasmine-2.0.0/jasmine',
      'jasmine-html' : '../jasmine-2.0.0/jasmine-html',
      'jasmine-boot' : '../jasmine-2.0.0/boot',
      'spec' : '../spec',
      'test-util' : '../spec/test-util',
      'blanket' : 'third-party/blanket.1.1.5',
      'jasmine-blanket' : 'third-party/jasmine-blanket',
    },
    shim : {
      'jasmine-boot' : {
        deps : [ 'jasmine', 'jasmine-html' ],
        exports : 'jasmine'
      },
      'jasmine-html' : {
        deps : [ 'jasmine' ],
        exports : 'jasmine'
      },
      'jasmine' : {
        exports : 'jasmine'
      },
      'jasmine-blanket' : {
        deps : [ 'jasmine-boot', 'blanket' ],
        exports : 'blanket'
      }
    }
  });

  require([ 'jquery', 'jasmine-boot', 'jasmine-blanket' ], function($, jasmine, blanket) {

//    blanket.options('debug', true);
//    blanket.options('filter', 'js/');

    blanket.options('antifilter', ['js/third-party', '../spec/', 'js/text.js']); // data-cover-only
    blanket.options('branchTracking', true); // one of the data-cover-flags
    
    var jasmineEnv = jasmine.getEnv();
    jasmineEnv.addReporter(new jasmine.BlanketReporter());

    jasmineEnv.updateInterval = 1000;

    var specs = [];

    specs.push('spec/view/forecast-view-test');

    specs.push('spec/view/main-view-test');
    specs.push('spec/app-test');
    specs.push('spec/base-test');

    $(document).ready(function() {
      require(specs, function(spec) {
        window.onload();
      });
    });
  });
});
