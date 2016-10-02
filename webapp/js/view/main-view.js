define([ 'jquery', 'underscore', 'backbone', "text!templates/main-view.html" ], function() {

  "use strict";
  var $ = require('jquery');
  var _ = require('underscore');
  var Backbone = require('backbone');
  var template = require("text!templates/main-view.html");

  var MainView = Backbone.View.extend({
    className : 'main',
    events : {
      "click button" : "onSearch",
      'keypress input[type=text]' : 'onKeyPress'
    },
    initialize : function(options) {
      _.bindAll(this, 'render');
      this.template = _.template(template);
    },
    render : function() {
      this.$el.append(this.template());
      return this;
    },
    onKeyPress : function(e) {
      if (e.keyCode === 13) {
        this.onSearch();
      }
    },
    onSearch : function(e) {
      var text = this.$('input[type="text"]').val();
      if (text.trim().length <= 1) {
        return;
      }
      this.trigger('search', text);

    },
    hide : function() {
      this.$('#search').hide();
    },
    show : function() {
      this.$('#search').show();
    }

  });
  return MainView;
});