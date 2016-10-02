define([ 'jquery', 'view/main-view', 'view/forecast-view', 'model/location-results', 'model/forecast-results', 'view/control-view', 'view/message-view',
    'view/info-view', 'model/location-model', 'persistence', 'router' ], function($) {

  "use strict";

  var InfoView = require('view/info-view');
  var MainView = require('view/main-view');
  var ForecastView = require('view/forecast-view');
  var ControlView = require('view/control-view');
  var MessageView = require('view/message-view');

  var LocationResults = require('model/location-results');
  var ForecastResults = require('model/forecast-results');
  var LocationModel = require('model/location-model');

  var Router = require('router');
  var Persistence = require('persistence');

  if (typeof Array.prototype.forEach !== 'function') {
    Array.prototype.forEach = function(callback, context) {
      for (var i = 0; i < this.length; i++) {
        callback.apply(context, [ this[i], i, this ]);
      }
    };
  }
  if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function() {
      return this.replace(/^\s+|\s+$/g, '');
    };
  }

  var App = function() {

  };

  App.prototype.initialize = function() {

    var persistence = new Persistence();
    var controlModel = new Backbone.Model();
    controlModel.set('windInfo', persistence.getWindInfo());
    controlModel.on('change:windInfo', function() {
      persistence.setWindInfo(controlModel.get('windInfo'));
    });
    var locationResults = new LocationResults();
    var forecastResults = new ForecastResults();
    var infoView = new InfoView();
    var messageView = new MessageView();

    var controlView = new ControlView({
      model : controlModel
    });
    var locationModel = new LocationModel();

    var onError = function() {
      forecastView.hide();
      messageView.show('There was a problem<br />Please try again later');
    };
    locationResults.on('error', onError);
    forecastResults.on('error', onError);

    var mainView = new MainView({});
    var forecastView = new ForecastView({
      locationResults : locationResults,
      forecastResults : forecastResults,
      locationModel : locationModel,
      controlModel : controlModel
    });

    $('body').append(mainView.render().$el);
    $('body').append(controlView.render().$el);

    $('body').append(forecastView.render().$el);
    $('body').append(messageView.render().$el);
    $('body').append(infoView.render().$el);

    $('#loading').hide();
    messageView.hide();
    controlView.hide();
    forecastView.on('results', function(found) {
      controlView.toggle(found);
      messageView.hide();
    });
    forecastView.on('noResults', function() {
      mainView.show();
      forecastView.hide();
      messageView.show('No results found<br />Please check your spelling<br />');
    });

    mainView.on('search', function(text) {
      infoView.hide();

      if (/^\d+$/.exec(text)) {
        messageView.show("Sorry we don't support zip codes, please use a town/city name instead");
        return;
      } else if (/^\w{1,4}\d+\s*\d+\w{1,4}$/.exec(text) || /^\w{1,4}\d+$/.exec(text)) {
        messageView.show("Sorry we don't support UK post codes, please use a town/city name instead");
        return;
      }
      var match = /^(.*?),.*$/.exec(text);
      if (match) {
        locationResults.text = match[1];
      } else {
        locationResults.text = text;
      }
      locationResults.fetch();
      locationResults.trigger('fetch');
      mainView.hide();
    });

    var router = new Router();

    locationModel.on('change', function() {
      var hash = [];
      locationModel.get('ids').forEach(function(id) {
        hash.push(id.toString(36));
      });
      router.navigate("/forecasts/" + hash.join(","));
    });
    router.on('route:forecasts', function(hash) {
      if (/[0-9a-z]{8}/.exec(hash)) {
        return;
      }
      var locations = []
      hash.split(",").forEach(function(base36) {
        locations.push(parseInt(base36, 36));
      });
      if (locations.length > 0) {
        forecastResults.setIds(locations.join(","));
        forecastResults.fetch();
      }
      forecastView.onLocationResultsSearch();
      infoView.remove();
      mainView.hide();
    });

    router.on('route:defaultRoute', function() {
      mainView.show();
      forecastView.hide();
    });

    Backbone.history.start({
      pushState : true
    });

    $('#header').click(function() {
      router.navigate("", {
        trigger : true
      });
    });
  };

  return App;
});