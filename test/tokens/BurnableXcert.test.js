const BurnableXcert = artifacts.require('BurnableXcert');
const util = require('ethjs-util');
const assertRevert = require('../helpers/assertRevert');

contract('BurnableXcert', (accounts) => {
  let xcert;
  let id1 = web3.sha3('test1');
  let id2 = web3.sha3('test2');
  let id3 = web3.sha3('test3');
  let id4 = web3.sha3('test4');
  let mockProof = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8";

  beforeEach(async function () {
    xcert = await BurnableXcert.new('Foo', 'F');
  });

  it('destroys NFToken id 1', async () => {
    await xcert.mint(accounts[0], id1, mockProof, 'url1');
    await xcert.burn(id1);
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

  it('throws when trying to destory an already destroyed NFToken id 1', async () => {
    await xcert.mint(accounts[0], id1, mockProof, 'url1');
    await xcert.burn(id1);
    await assertRevert(xcert.burn(id1));
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

  it('throws when trying to destory NFToken you are not the owner of', async () => {
    await xcert.mint(accounts[1], id2, mockProof, 'url2');
    await assertRevert(xcert.burn(id2));
    const count = await xcert.balanceOf(accounts[1]);
    assert.equal(count, 1);
  });
});
