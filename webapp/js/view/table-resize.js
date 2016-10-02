define([ 'jquery', 'underscore' ], function() {

  "use strict";
  var $ = require('jquery');
  var _ = require('underscore');

  var TableResize = function(options) {
    this.table = $(options.table);
    this.nextButton = $(options.nextButton);
    this.previousButton = $(options.previousButton);
    $(this.nextButton).click(_.bind(this.next, this));
    $(this.previousButton).click(_.bind(this.previous, this));

    this.columnWidth = 200;
    this.headerWidth = 100;
    this.resize();
    $(window).resize(_.bind(this.resize, this));
  };
  TableResize.prototype.next = function() {
    if (this.isNext()) {
      this.animateOut(this.visible);
      this.visible++;
      this.animateIn(this.visible + this.visibleCols - 1);

      this.quickUpdate();
      this.buttonsUpdate();
    }
  };
  TableResize.prototype.previous = function() {
    if (this.isPrevious()) {
      this.animateOut(this.visible + this.visibleCols - 1);
      this.visible--;
      this.animateIn(this.visible);
      this.quickUpdate();
      this.buttonsUpdate();
    }
  };
  TableResize.prototype.setPointer = function(pointer) {
    this.animateOut(this.visible);
    this.visible = pointer;
    this.animateIn(this.visible + this.visibleCols - 1);

    this.quickUpdate();
    this.buttonsUpdate();
  };
  TableResize.prototype.isNext = function() {
    return this.visible + this.visibleCols < this.columnCount - 1;
  };
  TableResize.prototype.isPrevious = function() {
    return this.visible > 0;
  };
  TableResize.prototype.buttonsUpdate = function() {
     this.nextButton[0].disabled = !this.isNext();
     this.previousButton[0].disabled = !this.isPrevious();

  };
  TableResize.prototype.update = function() {
    this.resize();
  };
  TableResize.prototype.resize = function() {
    this.columnCount = this.table.find('tr').eq(0).find('td,th').length;
    this.visibleCols = this.getVisibleColumns();
    this.visible = 0;
    this.quickUpdate();
    this.buttonsUpdate();
  };
  TableResize.prototype.quickUpdate = function() {
    var i;
    for (i = 0; i < this.columnCount; i++) {
      this.setColumnVisible(i, i >= this.visible && i < this.visible + this.visibleCols);
    }
  };

  TableResize.prototype.getVisibleColumns = function() {
    var visibleCols = ($(window).width() - this.headerWidth) / this.columnWidth;
    visibleCols = Math.floor(visibleCols);
    if (visibleCols < 1) {
      visibleCols = 1;
    }
    return visibleCols;
  };

  TableResize.prototype.getColumn = function(colIndex) {
    var cells = $([]);
    this.table.find("tr").each(function(rowIndex, row) {
      var cell = $(row).find('td,th').eq(colIndex + 1);
      cells = cells.add(cell);
    });
    return cells;
  };
  TableResize.prototype.setColumnVisible = function(colIndex, visible) {
    this.getColumn(colIndex).toggle(visible);
  };

  TableResize.prototype.animateIn = function(colIndex) {
    // var cells = this.getColumn(colIndex);
    // cells.css('margin-left', '-100px');
    // cells.toggle(true);
    //
    // cells.animate({
    // marginLeft : '0px',
    // duration:5000
    // });
  };
  TableResize.prototype.animateOut = function(colIndex) {
    // var cells = this.getColumn(colIndex);
    // cells.css('margin-left', '0px');
    // cells.animate({
    // marginLeft : '100px',
    // duration:5000
    // }, {
    // complete : function() {
    // cells.toggle(false);
    // }
    // });
  };
  return TableResize;
});