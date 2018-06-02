const MutableXcert = artifacts.require('MutableXcertMock');
const util = require('ethjs-util');
const web3Util = require('web3-utils');
const assertRevert = require('@0xcert/ethereum-erc721/test/helpers/assertRevert');

contract('MutableXcertMock', (accounts) => {
  let xcert;
  const id1 = web3.sha3('test1');
  const proof = '1e205550c271490347e5e2393a02e94d284bbe9903f023ba098355b8d75974c8';
  const config = [web3Util.padLeft(web3Util.numberToHex(1821195657), 64)];
  const data = [web3Util.padLeft(web3Util.numberToHex(3), 64)];
  const data2 = [web3Util.padLeft(web3Util.numberToHex(5), 64)];

  beforeEach(async function () {
    xcert = await MutableXcert.new('Foo', 'F', '0xa65de9e6');
  });

  it('correctly changes xcert data.', async () => {
    await xcert.mint(accounts[1], id1, 'url', proof, config, data);
    let tokenData = await xcert.tokenDataValue.call(id1, 0);
    assert.equal(tokenData, data);

    await xcert.setTokenData(id1, data2);
    tokenData = await xcert.tokenDataValue.call(id1, 0);
    assert.equal(tokenData, data2);
  });

  it('reverts trying to change data from a none authorized address.', async () => {
    await xcert.mint(accounts[1], id1, 'url', proof, config, data);
    await assertRevert(xcert.setTokenData(id1, data2, {from: accounts[1]}));
  });

  it('correctly changes xcert data from authorized address.', async () => {
    await xcert.mint(accounts[1], id1, 'url', proof, config, data);
    await xcert.setAuthorizedAddress(accounts[1], true);

    await xcert.setTokenData(id1, data2, {from: accounts[1]});
    const tokenData = await xcert.tokenDataValue.call(id1, 0);
    assert.equal(tokenData, data2);
  });
});
