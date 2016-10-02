define([], function() {

  "use strict";

  var Persistence = function() {};

  Persistence.prototype.isSupported = function() {
    return typeof (Storage) !== "undefined" && window.localStorage;
  };
  Persistence.prototype.getWindInfo = function() {
    var value = false;
    var localValue;
    if (this.isSupported()) {
      localValue = window.localStorage.getItem('windInfo');
      if (localValue) {
        value = localValue === 'true';
      }
    }
    return value;
  };

  Persistence.prototype.setWindInfo = function(value) {
    if (this.isSupported()) {
      window.localStorage.setItem('windInfo', value);
    }
  };

  return Persistence;
});