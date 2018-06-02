const RevokableXcert = artifacts.require('RevokableXcertMock');
const util = require('ethjs-util');
const web3Util = require('web3-utils');
const assertRevert = require('@0xcert/ethereum-erc721/test/helpers/assertRevert');

contract('RevokableXcertMock', (accounts) => {
  let xcert;
  const id1 = web3.sha3('test1');
  const id2 = web3.sha3('test2');
  const id3 = web3.sha3('test3');
  const id4 = web3.sha3('test4');
  const proof = '1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8';
  const config = [web3Util.padLeft(web3Util.numberToHex(1821195657), 64)];
  const data = [];

  beforeEach(async function () {
    xcert = await RevokableXcert.new('Foo', 'F', '0xa65de9e6');
  });

  it('revokes NFT id 1', async () => {
    await xcert.mint(accounts[1], id1, 'url', proof, config, data);
    await xcert.revoke(id1, {from: accounts[0]});
    const count = await xcert.balanceOf(accounts[1]);
    assert.equal(count, 0);
  });

  it('throws when trying to revoke an already revoked NFT id 1', async () => {
    await xcert.mint(accounts[1], id1, 'url', proof, config, data);
    await xcert.revoke(id1, {from: accounts[0]});
    await assertRevert(xcert.revoke(id1, {from: accounts[0]}));
    const count = await xcert.balanceOf(accounts[1]);
    assert.equal(count, 0);
  });
});
