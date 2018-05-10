const Xcert = artifacts.require('XcertMock');
const util = require('ethjs-util');
const assertRevert = require('../helpers/assertRevert');

contract('XcertMock', (accounts) => {
  let xcert;
  let id1 = web3.sha3('test1');
  let id2 = web3.sha3('test2');
  let id3 = web3.sha3('test3');
  let id4 = web3.sha3('test4');
  let mockProof = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8";
  let mockProof2 = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974d7";

  beforeEach(async function () {
    xcert = await Xcert.new('Foo', 'F');
    await xcert.mint(accounts[0], id1, mockProof, 'url1');
  });

  it('destroys NFToken id 1', async () => {
    await xcert.burn(id1);
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

  it('reverts trying to transfer when transfers are disabled', async () => {
    await xcert.setPause(true);
    await assertRevert(xcert.transferFrom(accounts[0], accounts[1], id1));
  });

  it('correctly chains additional proof', async () => {
    await xcert.chain(id1, mockProof2);
    var proof = await xcert.tokenProof(id1);
    assert.equal(proof, mockProof2);
  });

  it('revokes NFToken id 1', async () => {
    await xcert.revoke(id1, {from: accounts[0]});
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

});
