const PausableXcert = artifacts.require('PausableXcertMock');
const util = require('ethjs-util');
const web3Util = require('web3-utils');
const assertRevert = require('@0xcert/ethereum-erc721/test/helpers/assertRevert');

contract('PausableXcertMock', (accounts) => {
  let xcert;
  const id1 = web3.sha3('test1');
  const id2 = web3.sha3('test2');
  const id3 = web3.sha3('test3');
  const id4 = web3.sha3('test4');
  const proof = '1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8';
  const config = [web3Util.padLeft(web3Util.numberToHex(1821195657), 64)];
  const data = [];

  beforeEach(async function () {
    xcert = await PausableXcert.new('Foo', 'F', '0xa65de9e6');
  });

  it('correctly sets pause state', async () => {
    const { logs } = await xcert.setPause(true);
    const isPausedEvent = logs.find(e => e.event === 'IsPaused');
    assert.notEqual(isPausedEvent, undefined);
    const pauseState = await xcert.isPaused();
    assert.equal(pauseState, true);
  });

  it('reverts trying to set the same pause state', async () => {
    await assertRevert(xcert.setPause(false));
  });

  it('reverts when someone else then the owner tries to change pause state', async () => {
    await assertRevert(xcert.setPause(true, {from: accounts[1]}));
  });

  it('succefully transfers when NFT is not paused', async () => {
    await xcert.mint(accounts[0], id1, 'url', proof, config, data);
    await xcert.transferFrom(accounts[0], accounts[1], id1);
    const owner = await xcert.ownerOf(id1);
    assert.equal(owner, accounts[1]);
  });

  it('reverts trying to transfer when NFT is paused', async () => {
    await xcert.mint(accounts[0], id1, 'url', proof, config, data);
    await xcert.setPause(true);
    await assertRevert(xcert.transferFrom(accounts[0], accounts[1], id1));
  });
});
