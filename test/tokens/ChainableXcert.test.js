const ChainableXcert = artifacts.require('ChainableXcert');
const util = require('ethjs-util');
const assertRevert = require('../helpers/assertRevert');

contract('ChainableXcert', (accounts) => {
  let xcert;
  let id1 = web3.sha3('test1');
  let mockProof = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8";
  let mockProof2 = "1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974d5";

  beforeEach(async function () {
    xcert = await ChainableXcert.new('Foo', 'F');
    await xcert.mint(accounts[0], id1, mockProof, 'url1');
  });

  it('correctly chains additional proof', async () => {
    await xcert.chain(id1, mockProof2);
    var proof = await xcert.tokenProof(id1);
    assert.equal(proof, mockProof2);
  });

  it('reverts trying to chain empty proof', async () => {
    await assertRevert(xcert.chain(id1, ""));
  });

  it('correctly gets proof by index', async () => {
    await xcert.chain(id1, mockProof2);
    var proof = await xcert.tokenProofByIndex(id1, 1);
    assert.equal(proof, mockProof2);
  });

  it('reverts trying to get proof for none existant index', async () => {
    await assertRevert(xcert.tokenProofByIndex(id1, 1));
  });

  it('returns correct proof count', async () => {
    var proofCount = await xcert.tokenProofCount(id1);
    assert.equal(proofCount, 1);

    await xcert.chain(id1, mockProof2);
    proofCount = await xcert.tokenProofCount(id1);
    assert.equal(proofCount, 2);
  });
});
