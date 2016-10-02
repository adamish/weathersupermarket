define(['backbone'], function(Backbone) {
  var ForecastResult = Backbone.Model.extend({});
  var ForecastResults = Backbone.Collection.extend({
    url : function() {
      return "app/forecasts/" + this.ids;
    },
    model : ForecastResult,
    setIds : function(ids) {
      this.ids = ids;
    }
  });
  return ForecastResults;
});
