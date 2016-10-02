define([ 'jquery', 'underscore', 'backbone', 'moment', 'view/location-view', 'view/table-resize', 'model/forecast-results',
    "text!templates/forecast-view.html", "text!templates/forecast-cell.html", "text!templates/forecast-header.html" ], function() {
  var ForecastResults = require('model/forecast-results');
  var templateForecastView = require('text!templates/forecast-view.html');
  var templateForecastCell = require('text!templates/forecast-cell.html');
  var templateForecastHeader = require('text!templates/forecast-header.html');

  var LocationView = require('view/location-view');
  var $ = require('jquery');
  var _ = require('underscore');
  var Backbone = require('backbone');
  var moment = require('moment');
  var TableResize = require('view/table-resize');

  var ForecastView = Backbone.View.extend({
    className : 'forecast-view',
    events : {},
    initialize : function(options) {
      _.bindAll(this, 'render', 'onLocationResults', 'updateWindInfo', 'onLocationResultsSearch', 'onForecastResults');
      this.template = _.template(templateForecastView);
      this.templateCell = _.template(templateForecastCell);
      this.templateHeader = _.template(templateForecastHeader);
      this.locationResults = options.locationResults;
      this.locationModel = options.locationModel;
      this.controlModel = options.controlModel;
      this.controlModel.on('change:windInfo', this.updateWindInfo);
      this.locationResults.on('fetch', this.onLocationResultsSearch);
      this.locationResults.on('sync', this.onLocationResults);

      this.forecastResults = options.forecastResults;
      this.forecastResults.on('sync', this.onForecastResults);

      this.locationViews = [];
      this.data = {};
    },
    render : function() {
      this.$el.append(this.template());
      this.tableResize = new TableResize({
        table : this.$('table')[0],
        nextButton : this.$('.next')[0],
        previousButton : this.$('.previous')[0]
      });
      this.hide();
      return this;
    },
    hide : function() {
      this.$el.hide();
      this.clearTable();
      this.$('div.results').hide();
      this.locationModel.set('ids', []);
    },
    onLocationChange : function(locationView) {
      locationView.setLoading();
      this.forecastResults.setIds(locationView.getLocation());
      this.forecastResults.fetch();
      this.updateLocations();
    },
    updateLocations : function() {
      var locations = [];
      this.locationViews.forEach(function(view) {
        if (view.isLocationValid()) {
          locations.push(view.getLocation());
        }
      });
      this.locationModel.set('ids', locations);
    },
    loadAll : function() {
      this.locationViews.forEach(function(view) {
        if (view.isLocationValid()) {
          view.setLoading();
        }
      });
      var ids = this.locationModel.get('ids');
      this.forecastResults.setIds(this.locationModel.get('ids').join(','));
      if (ids.length > 0) {
        this.forecastResults.fetch();
      } else {
        Backbone.history.navigate('/no-results');
        this.trigger('noResults', true);
      }
    },
    onLocationResults : function() {
      this.setLoading(false);
      this.$('div.results').show();

      this.data = {};
      this.locationViews.forEach(function(locationView) {
        locationView.remove();
      });
      this.locationViews = [];

      this.locationResults.models.forEach(function(it) {
        var locationView = new LocationView({
          model : it
        });
        locationView.render();
        this.locationViews.push(locationView);

        this.data[it.get('provider')] = {};
        this.listenTo(locationView, 'change', this.onLocationChange);
      }, this);

      this.addLocationViews();

      this.$el.show();
      this.updateLocations();
      this.loadAll();
    },
    addLocationViews : function() {
      this.locationViews.forEach(function(locationView) {
        if (locationView.getResults().length >= 0) {
          this.$('tbody').append(locationView.$el);
        }
      }, this);
      this.locationViews.forEach(function(locationView) {
        if (locationView.getResults().length === 0) {
          this.$('tbody').append(locationView.$el);
        }
      }, this);
    },
    onLocationResultsSearch : function() {
      this.$el.show();
      this.$('div.results').hide();
      this.clearTable();
      this.setLoading(true);
    },
    setLoading : function(loading) {
      if (loading) {
        this.$('div.loading').show();
        this.$el.addClass('loading');
      } else {
        this.$('div.loading').hide();
        this.$el.removeClass('loading');
      }
    },
    onForecastResults : function() {
      this.setLoading(false);
      this.$('div.results').show();

      if (this.locationViews.length === 0) {
        this.forecastResults.forEach(function(results) {
          var model = new Backbone.Model({
            results : [ {
              name : results.attributes.locationName,
              id : -1
            } ],
            provider : results.attributes.provider
          });
          var locationView = new LocationView({
            model : model
          });
          locationView.render();

          this.locationViews.push(locationView);
        }, this);
        this.addLocationViews();
      }

      this.dateIndex = 0;
      this.buildTable();

      var resultCount = 0;
      _.each(this.data, function(dates) {
        resultCount += _.size(dates);
      });
      if (resultCount > 0) {
        this.renderTable();
      }
      this.trigger('results', resultCount > 0);

    },
    /**
     * Build 2d table by (location, date). Merge new results into existing
     * results (deal with delta update).
     */
    buildTable : function() {
      var data = this.data;
      var datesUnique = {};
      var dates = [];

      this.forecastResults.forEach(function(results) {
        // overwrite any previous results
        data[results.attributes.provider] = {};
        t2 = data[results.attributes.provider];
        results.attributes.results.forEach(function(result) {
          var date = result.date;
          var array = t2[date];
          if (array === undefined) {
            array = [];
            t2[date] = array;
          }
          array.push(result);
        });
      });

      var provider;
      for (provider in data) {
        for (date in data[provider]) {
          if (datesUnique[date] === undefined) {
            dates.push(date);
            datesUnique[date] = true;
          }
        }
      }

      dates.sort();
      this.dates = dates;
      this.dates = this.dates.slice(0, Math.min(6, this.dates.length));
    },
    clearTable : function() {
      this.$('thead th:gt(0)').remove();
      this.$('tbody td').remove();
      this.trigger('results', false);
    },
    renderTable : function() {
      var date = this.dates[this.dateIndex];
      var location;
      this.clearTable();
      this.dates.forEach(function(date) {
        this.$('thead tr').append(this.templateHeader({
          moment : moment,
          date : date
        }));
      }, this);

      var table = this.$('table tbody');
      this.locationViews.forEach(function(locationView) {
        var row = locationView.$el;
        var provider = locationView.getProvider();

        this.dates.forEach(function(date) {
          var data = this.data[provider][date];
          if (data) {
            row.append(this.templateCell({
              forecasts : data
            }));
          } else {
            row.append($('<td>No data available</td>').addClass('no-data'));
          }
        }, this);
      }, this);
      this.tableResize.update();
      this.selectDay();
      this.updateWindInfo();
    },
    updateWindInfo : function() {
      this.$('.wind-info').toggle(this.controlModel.get('windInfo'));
    },
    selectDay : function() {
      var now = new Date();
      var found = -1;
      var i = 0;
      var nowUnix = new Date().getTime() / 1000;

      for (i = 0; i < this.dates.length - 2; i++) {
        if (nowUnix >= this.dates[i] && nowUnix < this.dates[i + 1]) {
          found = i;
          break;
        }
      }
      var evening = now.getHours() >= 20;
      if (evening) {
        found++;
      }
      if (found >= 0) {
        this.tableResize.setPointer(found);
      }

    }

  });

  return ForecastView;
});
