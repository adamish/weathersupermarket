define([ 'view/forecast-view', 'test-util' ], function(ForecastView, testutil) {

  var testUtil = require('test-util');

  describe("Forecast view", function() {
    var view = {};
    var locationResults = {};
    var forecastResults = {};
    beforeEach(function() {

      var builder = new testUtil.ResultBuilder();
      builder.noResult("metoffice");
      builder.noResult("weatherunderground");
      builder.result("bbc", "3", "Manchester, Disbury");
      builder.result("bbc", "1", "Huddersfield");
      builder.result("bbc", "2", "York");
      builder.result("bbc", "4", "Manchester, Withington");

      builder.result("accuweather", "4", "Bradford");

      builder.noResult("metcheck");
      builder.noResult("weatherchannel");

      locationResults = new Backbone.Collection(builder.build());

      var forecastBuilder = new testUtil.ForecastResults();
      forecastBuilder.add(new Date(2014, 0, 28), "am", 13, 15, "Rainy", 1, 'bbc', 1, "http://example.org/1", 'rain1', 8, 'NW');
      forecastBuilder.add(new Date(2014, 0, 28), "pm", 13, 15, "Very rainy", 1, 'bbc', 2, "http://example.org/1", 'rain2', 8, 'NE');
      forecastBuilder.add(new Date(2014, 0, 29), "foo bar", 13, 15, "Snow", 1, 'bbc', 3, "http://example.org/1", 'snow1', 8, 'S');
      forecastBuilder.add(new Date(2014, 0, 30), "9:00", 13, 15, "Sunny", 1, 'metoffice', 4, "http://example.org/1", 'sun');
      forecastBuilder.add(new Date(2014, 0, 30), "12:00", 13, 15, "Partial sunny", 1, 'metoffice', 4, "http://example.org/1", 'cloud-sun');
      forecastResults = new Backbone.Collection(forecastBuilder.build());
      forecastResults.url = 'foo/bar';
      forecastResults.setIds = function() {

      };
      var locationModel = new Backbone.Model();

      view = new ForecastView({
        locationResults : locationResults,
        forecastResults : forecastResults,
        locationModel : locationModel,
        controlModel: new Backbone.Model()
      });
      
      spyOn(Backbone, 'sync');
    });
    it("render", function() {
      view.render();
    });
    it("show location results", function() {
      view.render();
      locationResults.trigger('sync');
      expect(view.$('tr[data-provider="bbc"]').text()).toContain('Huddersfield');
      expect(view.$('tr[data-provider="bbc"]').text()).toContain('York');
      expect(view.$('tr[data-provider="bbc"]').text()).toContain('Withington');
    });
    it("show location search error", function() {
      view.render();
      locationResults.trigger('error');
    });
    it("update forecast", function() {
      view.render();
      locationResults.trigger('sync');
      forecastResults.trigger('sync');
      
      var forecastBuilder = new testUtil.ForecastResults();
      forecastBuilder.add(new Date(2014, 0, 30), "9:00", 13, 15, "Thunder", 1, 'metoffice', 4, "http://example.org/1", 'sun');
      forecastBuilder.add(new Date(2014, 0, 30), "12:00", 13, 15, "Lightning", 1, 'metoffice', 4, "http://example.org/1", 'cloud-sun');
      var data = forecastBuilder.build();

      Backbone.sync.and.callFake(function(method, model, callbacks) {
        callbacks.success(data);
      });
      forecastResults.fetch();
      expect(view.$el.text()).toContain('Rainy');
      expect(view.$el.text()).toContain('Thunder');
      expect(view.$el.text()).toContain('Lightning');
    });
    it("show forecast dates", function() {
      view.render();
      locationResults.trigger('sync');
      forecastResults.trigger('sync');
      expect(view.$el.text()).toContain('28th');
      expect(view.$el.text()).toContain('29th');
      expect(view.$el.text()).toContain('30th');
    });
    it("show forecast results", function() {
      view.render();
      locationResults.trigger('sync');
      forecastResults.trigger('sync');
      $('body').append(view.$el);
      expect(view.$el.text()).toContain('am:');
      expect(view.$el.text()).toContain('pm:');
      expect(view.$el.text()).not.toContain('foo bar');
      expect(view.$el.text()).toContain('Rainy');
      expect(view.$el.text()).toContain('Snow');
    });

  });
});