const RevokableXcert = artifacts.require('RevokableXcert');
const util = require('ethjs-util');
const assertRevert = require('../helpers/assertRevert');

contract('RevokableXcert', (accounts) => {
  let xcert;
  let id1 = web3.sha3('test1');
  let id2 = web3.sha3('test2');
  let id3 = web3.sha3('test3');
  let id4 = web3.sha3('test4');
  let mockProof = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8";

  beforeEach(async function () {
    xcert = await RevokableXcert.new('Foo', 'F');
  });

  it('revokes NFToken id 1', async () => {
    await xcert.mint(accounts[1], id1, mockProof, 'url1');
    await xcert.revoke(id1, {from: accounts[0]});
    const count = await xcert.balanceOf(accounts[1]);
    assert.equal(count, 0);
  });

  it('throws when trying to revoke an already revoked NFToken id 1', async () => {
    await xcert.mint(accounts[1], id1, mockProof, 'url1');
    await xcert.revoke(id1, {from: accounts[0]});
    await assertRevert(xcert.revoke(id1, {from: accounts[0]}));
    const count = await xcert.balanceOf(accounts[1]);
    assert.equal(count, 0);
  });
});
