define([], function() {

  var testUtil = {};
  testUtil.ResultBuilder = function() {
    this.results = [];
    this.noResults = [];
  };
  testUtil.ResultBuilder.prototype.result = function(provider, location, name) {
    this.results.push({
      id : location,
      name : name,
      provider : provider
    });
    return this;
  };
  testUtil.ResultBuilder.prototype.noResult = function(provider) {
    this.noResults.push({
      provider : provider,
      results : []
    });
    return this;
  };
  testUtil.ResultBuilder.prototype.build = function() {
    var group = {};
    this.results.forEach(function(it) {
      var perProvider = group[it.provider];
      if (perProvider === undefined) {
        perProvider = [];
        group[it.provider] = perProvider;
      }
      perProvider.push({
        id : it.id,
        name : it.name
      });
    });
    var key;
    var result = [];
    for (key in group) {
      result.push({
        results : group[key],
        provider : key
      });
    }
    return result.concat(this.noResults);
  };

  testUtil.ForecastResults = function() {
    this.results = [];
    this.locations = {};
  };
  testUtil.ForecastResults.prototype.add = function(date, daytime, min, max, summary, location, provider, stars, link, symbol, windSpeed, windDir) {
    var array = this.locations[provider];
    if (array === undefined) {
      array = []
      this.locations[provider] = array;
      this.results.push({
        location : location,
        provider : provider,
        results : array
      });
    }
    array.push({
      date : date.getTime() / 1000,
      daytime : daytime,
      min : min,
      max : max,
      summary : summary,
      stars : stars,
      link : link,
      symbol : symbol,
      windSpeed: windSpeed,
      windDir: windDir
    });
  };
  testUtil.ForecastResults.prototype.build = function() {
    return this.results;
  };

  return testUtil;
});