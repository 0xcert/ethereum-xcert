const PausableXcert = artifacts.require('PausableXcert');
const util = require('ethjs-util');
const assertRevert = require('../helpers/assertRevert');

contract('PausableXcert', (accounts) => {
  let xcert;
  let id1 = web3.sha3('test1');
  let id2 = web3.sha3('test2');
  let id3 = web3.sha3('test3');
  let id4 = web3.sha3('test4');
  let mockProof = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8";

  beforeEach(async function () {
    xcert = await PausableXcert.new('Foo', 'F');
  });

  it('correctly sets pause state', async () => {
    var { logs } = await xcert.setPause(true);
    let isPausedEvent = logs.find(e => e.event === 'IsPaused');
    assert.notEqual(isPausedEvent, undefined);
    var pauseState = await xcert.isPaused();
    assert.equal(pauseState, true);
  });

  it('reverts trying to set the same pause state', async () => {
    await assertRevert(xcert.setPause(false));
  });

  it('reverts when someone else then the owner tries to change pause state', async () => {
    await assertRevert(xcert.setPause(true, {from: accounts[1]}));
  });

  it('succefully transfers when token is not paused', async () => {
    await xcert.mint(accounts[0], id1, mockProof, 'url1');
    await xcert.transferFrom(accounts[0], accounts[1], id1);
    var owner = await xcert.ownerOf(id1);
    assert.equal(owner, accounts[1]);
  });

  it('reverts trying to transfer when token is paused', async () => {
    await xcert.mint(accounts[0], id1, mockProof, 'url1');
    await xcert.setPause(true);
    await assertRevert(xcert.transferFrom(accounts[0], accounts[1], id1));
  });
});
