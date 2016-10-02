define([ 'jquery', 'underscore', 'backbone', "text!templates/info-view.html" ], function() {

  "use strict";
  var $ = require('jquery');
  var _ = require('underscore');
  var Backbone = require('backbone');
  var template = require("text!templates/info-view.html");

  var InfoView = Backbone.View.extend({
    className : 'info-view',
    initialize : function(options) {
      _.bindAll(this, 'render');
      this.template = _.template(template);
    },
    render : function() {
      this.$el.append(this.template());
      return this;
    },
    hide: function() {
      this.$el.remove();
    }

  });
  return InfoView;
});