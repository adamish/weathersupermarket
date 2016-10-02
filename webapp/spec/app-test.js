define([ 'app', 'test-util' ], function(App, testutil) {

  describe("app", function() {
    it("initialize", function() {
      (new App()).initialize();
    });
  });
});