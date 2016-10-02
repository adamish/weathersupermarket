define([ 'jquery', 'underscore', 'backbone', "text!templates/control-view.html" ], function() {

  "use strict";
  var $ = require('jquery');
  var _ = require('underscore');
  var Backbone = require('backbone');
  var template = require("text!templates/control-view.html");

  var MainView = Backbone.View.extend({
    className : 'controls',
    events : {
      "click input.wind-info" : "onWindInfo",
    },
    initialize : function(options) {
      _.bindAll(this, 'render', 'hide', 'show');
      this.template = _.template(template);
      this.model = options.model;
    },
    render : function() {
      this.$el.append(this.template());
      this.$('input.wind-info').prop('checked', this.model.get('windInfo'));
      return this;
    },
    onWindInfo : function() {
      this.model.set('windInfo', this.$('input.wind-info').is(':checked'));
    },
    hide: function() {
      this.$el.hide();
    },
    show: function() {
      this.$el.show();
    }, 
    toggle: function(show) {
      if (show) {
        this.show();
      } else {
        this.hide();
      }
    }
  });
  return MainView;
});