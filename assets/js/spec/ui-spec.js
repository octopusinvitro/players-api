describe('UI', function() {
  let ui;

  beforeEach(function() {
    ui = new UI();
  });

  it('says "UI"', function() {
    expect(ui.run()).toEqual('UI');
  });
});
