const Xcert = artifacts.require('Xcert');
const BurnableXcert = artifacts.require('BurnableXcert');
const PausableXcert = artifacts.require('PausableXcert');
const RevokableXcert = artifacts.require('RevokableXcert');
const Selector = artifacts.require('Selector');

contract('Selector', (accounts) => {

  let selector;

  beforeEach(async function () {
    selector = await Selector.new();
  });

  it('Checks Xcert selector', async () => {
    var xcert = await Xcert.new('Foo', 'F', '0xa65de9e6');
    var bytes = await selector.calculateXcertSelector();
    var supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks BurnableXcert selector', async () => {
    var xcert = await BurnableXcert.new('Foo', 'F', '0xa65de9e6');
    var bytes = await selector.calculateBurnableXcertSelector();
    var supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks PausableXcert selector', async () => {
    var xcert = await PausableXcert.new('Foo', 'F', '0xa65de9e6');
    var bytes = await selector.calculatePausableXcertSelector();
    var supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks RevokableXcert selector', async () => {
    var xcert = await RevokableXcert.new('Foo', 'F', '0xa65de9e6');
    var bytes = await selector.calculateRevokableXcertSelector();
    var supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

});
