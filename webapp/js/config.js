define([], function() {
  requirejs.config({
    baseUrl : 'js',
    paths : {
      async : 'third-party/async',
      jquery : 'third-party/jquery-1.11.0.min',
      underscore : 'third-party/underscore-1.5.2.min',
      backbone : 'third-party/backbone-1.1.0.min',
      moment : 'third-party/moment.2.5.1.min',
      templates : '../templates'
    },
    shim : {
      'backbone' : {
        deps : [ 'underscore', 'jquery' ],
        exports : 'Backbone'
      },
      'underscore' : {
        exports : '_'
      }
    }
  });
});
