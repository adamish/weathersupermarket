define([ 'jquery', 'underscore', 'backbone', "text!templates/forecast-row.html" ], function() {
  var template = require('text!templates/forecast-row.html');

  var $ = require('jquery');
  var _ = require('underscore');
  var Backbone = require('backbone');

  var LocationView = Backbone.View.extend({
    events : {
      "change select" : "onChangeSelect",
      "click button.change-location" : "onChangeClick"
    },
    initialize : function(options) {
      _.bindAll(this, 'render', 'onChangeSelect', 'getResults', 'getLocation', 'getProvider', 'isLocationValid', 'setLoading');
      this.template = _.template(template);
      this.model = options.model;
      this.location = null;
    },
    render : function() {
      var provider = this.model.get('provider');
      this.$el = $(this.template({
        name : provider
      }));
      this.populateDropdown();
      this.chooseDefault();
      this.updateLocation();
      this.delegateEvents();
      return this;
    },
    onChangeClick: function(e) {
      e.preventDefault();
      this.$('div.change').hide();
      this.$('select').show().click();
    },
    onChangeBlur: function(e) {
      this.$('div.change').show();
      this.$('select').hide();
    },
    onChangeSelect : function(e) {
      this.updateLocation();
      this.onChangeBlur();
      this.trigger('change', this);
    },
    updateLocation : function() {
      var found = null;
      var location;
      if (this.model.get('results').length > 0) {
        location = parseInt(this.$('select').val(), 10);
        this.model.get('results').forEach(function(result) {
          if (result.id === location) {
            found = result;
          }
        });
        this.location = location;
        if (found) {
          this.$('div.detail').text(this.getNiceName(found.name));
        }
      }
    },
    getNiceName: function(input) {
      var output = input;
      output = output.replace("United Kingdom", "UK");
      var m = /(.*),\s*(.*)/.exec(output);
      if (m && m[1] === m[2]) {
        output = m[1];
      }
      return output;
    },
    populateDropdown : function() {
      var results = this.model.get('results');
      var target = this.$('select');
      var location = this.$('div.detail');
      target.empty();
      var groups = {};
      var group;
      var i = 3;
      var matches;
      var loose = [];
      this.$('div.change').toggle(results.length > 1);

      // only show if choice to be made
      target.toggle(false);

      if (results.length === 0) {
        location.text('No results found').addClass("no-data");
        return;
      } else if (results.length === 1) {
        location.text(results[0].name);
      } else {
        location.text("");
      }

      results.sort(function(a, b) {
        if (a.name < b.name) {
          return 1;
        } else if (a.name > b.name) {
          return -1;
        } else {
          return 0;
        }
      });

      results.forEach(function(it) {
        matches = /(.*?),\s*(.*)/.exec(it.name);
        if (matches === null) {
          loose.push(it);
        } else {
          group = groups[matches[1]];
          if (group === undefined) {
            group = [];
            groups[matches[1]] = group;
          }
          it.shortName = matches[2];
          group.push(it);
        }
      });

      var groupKey;
      var optgroup;
      for (groupKey in groups) {
        group = groups[groupKey];
        if (group.length === 1) {
          delete groups[groupKey];
          loose.push(group[0]);
        }
      }

      for (groupKey in groups) {
        group = groups[groupKey];
        optgroup = $("<optgroup></optgroup>").attr('label', groupKey);
        group.forEach(function(it) {
          var content = $("<option></option>").text(it.shortName).val(it.id);
          optgroup.append(content);
        });
        target.append(optgroup);
      }

      loose.forEach(function(it) {
        var content = $("<option></option>").text(it.name).val(it.id);
        target.append(content);
      });

    },
    chooseDefault : function() {
      var selectDom = this.$('select');
      var found = -1;
      $(selectDom).find('option').each(function(index, optionDom) {
        var option = $(optionDom);
        var text = option.text();
        var value = option.attr('value');
        if (/GB/.exec(text)) {
          found = value;
        } else if (/UK/.exec(text)) {
          found = value;
        } else if (/United Kingdom/.exec(text)) {
          found = value;
        }
      });
      if (found >= 0) {
        $(selectDom).val(found);
      }
    },
    setLoading : function() {
      this.$('td').each(function(index, it) {
        $(it).empty().addClass('loading');
      });
    },
    getResults : function() {
      return this.model.get('results');
    },
    getLocation : function() {
      return this.location;
    },
    getProvider : function() {
      return this.model.get('provider');
    },
    isLocationValid : function() {
      return this.location !== null;
    }
  });

  return LocationView;
});
