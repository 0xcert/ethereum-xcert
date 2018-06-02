const BurnableXcert = artifacts.require('BurnableXcertMock');
const util = require('ethjs-util');
const web3Util = require('web3-utils');
const assertRevert = require('@0xcert/ethereum-erc721/test/helpers/assertRevert');

contract('BurnableXcertMock', (accounts) => {
  let xcert;
  const id1 = web3.sha3('test1');
  const id2 = web3.sha3('test2');
  const id3 = web3.sha3('test3');
  const id4 = web3.sha3('test4');
  const proof = '1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8';
  const config = [web3Util.padLeft(web3Util.numberToHex(1821195657), 64)];
  const data = [];

  beforeEach(async function () {
    xcert = await BurnableXcert.new('Foo', 'F', '0xa65de9e6');
  });

  it('destroys NFT id 1', async () => {
    await xcert.mint(accounts[0], id1, 'url', proof, config, data);
    await xcert.burn(id1);
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

  it('throws when trying to destory an already destroyed NFT id 1', async () => {
    await xcert.mint(accounts[0], id1, 'url', proof, config, data);
    await xcert.burn(id1);
    await assertRevert(xcert.burn(id1));
    const count = await xcert.balanceOf(accounts[0]);
    assert.equal(count, 0);
  });

  it('throws when trying to destory NFT you are not the owner of', async () => {
    await xcert.mint(accounts[1], id2, 'url2', proof, config, data);
    await assertRevert(xcert.burn(id2));
    const count = await xcert.balanceOf(accounts[1]);
    assert.equal(count, 1);
  });
});
