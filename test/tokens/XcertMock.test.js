const Xcert = artifacts.require('XcertMock');
const util = require('ethjs-util');
const web3Util = require('web3-utils');
const assertRevert = require('../../node_modules/@0xcert/ethereum-erc721/test/helpers/assertRevert');

contract('XcertMock', (accounts) => {
  let xcert;
  let id1 = web3.sha3('test1');
  let id2 = web3.sha3('test2');
  let id3 = web3.sha3('test3');
  let id4 = web3.sha3('test4');
  const proof = '1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8';
  let config = [web3Util.padLeft(web3Util.numberToHex(1821195657), 64)];
  let data = [];

  beforeEach(async function () {
    xcert = await Xcert.new('Foo', 'F', '0xa65de9e6');
    await xcert.mint(accounts[0], id1, 'url', proof, config, data);
  });

  it('destroys NFT id 1', async () => {
    await xcert.burn(id1);
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

  it('reverts trying to transfer when transfers are disabled', async () => {
    await xcert.setPause(true);
    await assertRevert(xcert.transferFrom(accounts[0], accounts[1], id1));
  });

  it('revokes NFT id 1', async () => {
    await xcert.revoke(id1, {from: accounts[0]});
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });
});
