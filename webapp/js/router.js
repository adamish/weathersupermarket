define([ 'backbone' ], function(Backbone) {

  "use strict";
  var Router = Backbone.Router.extend({
    routes : {
      "forecasts/:id" : "forecasts",
      "about" : "about",
      "" : 'defaultRoute'
    }
  });

  return Router;
});