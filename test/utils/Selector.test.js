const Xcert = artifacts.require('XcertMock');
const BurnableXcert = artifacts.require('BurnableXcertMock');
const PausableXcert = artifacts.require('PausableXcertMock');
const RevokableXcert = artifacts.require('RevokableXcertMock');
const MutableXcert = artifacts.require('MutableXcertMock');
const Selector = artifacts.require('Selector');

contract('Selector', (accounts) => {
  let selector;

  beforeEach(async function () {
    selector = await Selector.new();
  });

  it('Checks Xcert selector', async () => {
    const xcert = await Xcert.new('Foo', 'F', '0xa65de9e6');
    const bytes = await selector.calculateXcertSelector();
    const supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks BurnableXcert selector', async () => {
    const xcert = await BurnableXcert.new('Foo', 'F', '0xa65de9e6');
    const bytes = await selector.calculateBurnableXcertSelector();
    const supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks PausableXcert selector', async () => {
    const xcert = await PausableXcert.new('Foo', 'F', '0xa65de9e6');
    const bytes = await selector.calculatePausableXcertSelector();
    const supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks RevokableXcert selector', async () => {
    const xcert = await RevokableXcert.new('Foo', 'F', '0xa65de9e6');
    const bytes = await selector.calculateRevokableXcertSelector();
    const supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });

  it('Checks MutableXcert selector', async () => {
    const xcert = await MutableXcert.new('Foo', 'F', '0xa65de9e6');
    const bytes = await selector.calculateMutableXcertSelector();
    const supports = await xcert.supportsInterface(bytes);
    assert.equal(supports, true);
  });
});
