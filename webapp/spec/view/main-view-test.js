define([ 'view/main-view', 'test-util' ], function(MainView, testutil) {

  describe("Main view", function() {
    var view = {};
    beforeEach(function() {
      view = new MainView({

      });
    });
    it("render", function() {
      view.render();
    });
  });
});