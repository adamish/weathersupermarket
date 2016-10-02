define([ 'jquery', 'underscore', 'backbone', "text!templates/message-view.html" ], function() {

  "use strict";
  var $ = require('jquery');
  var _ = require('underscore');
  var Backbone = require('backbone');
  var template = require("text!templates/message-view.html");

  var MessageView = Backbone.View.extend({
    className : 'message-view',
    initialize : function(options) {
      _.bindAll(this, 'render', 'hide', 'show');
      this.template = _.template(template);
    },
    render : function() {
      this.$el.append(this.template());
      return this;
    },
    hide: function() {
      this.$el.hide();
    },
    show: function(message) {
      this.$('.content').html(message);
      this.$el.show();
    }

  });
  return MessageView;
});