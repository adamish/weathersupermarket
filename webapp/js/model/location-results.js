define(['backbone'], function(Backbone) {
  var LocationResult = Backbone.Model.extend({});

  var LocationResults = Backbone.Collection.extend({
    url : function() {
      return "app/search/" + this.text.toLowerCase().trim();
    },
    model : LocationResult
  });
  return LocationResults;
});
