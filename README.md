# ![Build Status](https://travis-ci.org/0xcert/ethereum-xcert.svg?branch=master)&nbsp;[![NPM Version](https://badge.fury.io/js/@0xcert%2Fethereum-xcert.svg)](https://badge.fury.io/js/0xcert%2Fethereum-xcert)&nbsp;[![Dependencies Status](https://david-dm.org/0xcert/ethereum-xcert.svg)](https://david-dm.org/0xcert/ethereum-xcert)&nbsp;[![Bug Bounty](https://img.shields.io/badge/bounty-pending-2930e8.svg)](https://github.com/0xcert/ethereum-xcert/issues)

# Xcert Token

This is the official implementation of the [Xcert](https://github.com/0xcert/0xcert/blob/981f05ffd366d085967bf99a6d24613e63e1c88e/specs/2.md) token for the Ethereum blockchain. This is an open source project build with [Truffle](http://truffleframework.com) framework.

Purpose of this implemetation is to provide a good starting point for anyone who wants to use and develop the low-level layer of the 0xcert protocol on the Ethereum blockchain. Instead of re-implementing the 0xcert specs yourself you can use this code which has gone through multiple audits and we hope it will be extensively used by the community in the future.

An Xcert is an extension of the [ERC-721](https://github.com/0xcert/ethereum-erc721/) implementation. It is an opinionated non-fungible token which carries a proof of a digital asset and supports additional 0xcert protocol features. You can read more about this in the official [0xcert protocol yellow paper](https://github.com/0xcert/whitepaper/blob/master/dist/0xcert-protocol.pdf).

## Installation

Requirements:
- NodeJS 9.0+ recommended.
- Windows, Linux or Mac OS X.

Simply clone the repository and install npm packages:

```
$ git clone git@github.com:0xcert/ethereum-xcert.git
$ cd ethereum-xcert
$ npm install
```

Make sure that everything has been set up correctly:

```
$ npm run test
```

All tests should pass.

## Structure

Since this is a Truffle project, you will find all tokens in `contracts/tokens/` directory. There are multiple implementations and you can select between:
- `Xcert.sol`: This is the base Xcert token implementation.
- `BurnableXcert.sol`: This implements optional support for token burning. It is useful if you want token owners to be able to burn them.
- `PausableXcert.sol`: This implements optional freeze for token transfers. It is useful if you want to be able to pause all token transfers at any time.
- `RevokableXcert.sol`: This implements optional revoking mechanism. It is useful if you want to allow owner of the Xcert contract to revoke any token at any time.

## Usage

The easiest way to start is to create a new file under `contracts/tokens/` (e.g. `MyXcertToken.sol`):

```sol
pragma solidity ^0.4.23;

import "../tokens/BurnableXcert.sol";

contract MyXcertToken is BurnableXcert {

  constructor(
    string _name,
    string _symbol,
    bytes4 _conventionId
  )
    BurnableXcert(_name, _symbol, _conventionId)
    public
  {
  }
}
```

That's it. Let's compile the contract:

```
$ npm run compile
```

The easiest way to deploy it locally and start interacting with the contract (minting and transferring tokens) is to deploy it on your personal (local) blockchain using [Ganache](http://truffleframework.com/ganache/). Follow the steps in the Truffle documentation which are described [here](http://truffleframework.com/docs/getting_started/project#alternative-migrating-with-ganache).

## Deploying on testnet (Ropsten)

Next step is to deploy the contract on the testnet.

Requirements:
- [geth](https://geth.ethereum.org/downloads/)
- Wallet with some ether.

Create a new file `migrations/2_mytoken_migration.js` and put in:

```js 
const MyXcertTokenContract = artifacts.require('./tokens/MyXcertToken.sol');

module.exports = function(deployer) {
  deployer.deploy(MyXcertTokenContract, 'MyXcertTest', 'MYXCT', '0x00000000');
};
```

Start `geth` and sync your client with the testnet (can take a little bit):

```
$ geth console --testnet --light --rpc --rpcaddr "localhost" --rpcport "8545" --rpccorsdomain "*" --rpcapi="db,eth,net,web3,personal,web3"
```

Open another terminal and create a new account (your "test" account wallet):

```
$ geth --testnet account new
```

**NOTE**: In this example the wallet address is  `0x8a1ed22651f4980c66579d6947059a97e09c61a7` (make sure you prepend the returned string with `0x` yourself). Your account address will be different! And don't forget the passphrase otherwise you won't be able to unlock your new account. Now, go and send some ether to it (you can get some [here](https://faucet.metamask.io/).

Open project's `truffle.js` and add the following:

```js
module.exports = {
  networks: {
    'ropsten': {
      host: 'localhost',
      port: 8545,
      network_id: '3', // Ropsten ID 3
      from: '0x8a1ed22651f4980c66579d6947059a97e09c61a7' // account address from which to deploy
    },
  },
};
```

Next, let's unlock your account:

```
$ npm run console -- --network ropsten
```

```
truffle(ropsten)> web3.personal.unlockAccount("0x8a1ed22651f4980c66579d6947059a97e09c61a7", "<PASSWORD>", 1500)
```

At last, deploy the contract:

```
$ npm run migrate -- --network ropsten
```

You can now interact with the contract. First get the address of the deployed contract:

```
$ npm run networks
```

You can also check it on Ropsten [etherscan](https://ropsten.etherscan.io/address/0x339cb3e015d2eb2b7156f01dc960c79708f02d3b). Then in the truffle console (second terminal):

```
> const { abi } = require('./build/contracts/MyXcertToken.json');
> const account0 = '0x8a1ed22651f4980c66579d6947059a97e09c61a7'; // your unlocked account
> const account1 = '0x9062dd79d7e4273889b234f6b0c840ca43280af6'; // another account (you can create it)
> const MyXcertTokenContract = web3.eth.contract(abi);
> const MyXcertTokenInstance = MyXcertTokenContract.at(<MyNFToken ADDRESS>);

> MyXcertTokenInstance.symbol();
'MYXCT'
> MyXcertTokenInstance.name();
'MyXcertTest'

// Minting Xcert tokens
// "1" - Token ID
// "http://www.random-art.org/img/large/199607.jpg" - Token URI; in this case to the picture generated from proof
// "4355a46b19d348dc2f57c046f8ef63d4538ebb936000f3c9ee954a27460dd865" - Token proof, calculated as sha256("1").
// [1, 2, 3, 4] - Random config options, first element is expiration date and thus currently set to Thu Jan  1 01:00:01 CET 1970 :).
// ["a", "b", "c"] -Random convention options
 
> MyXcertTokenInstance.mint(account1, "1", "http://www.random-art.org/img/large/199607.jpg", "4355a46b19d348dc2f57c046f8ef63d4538ebb936000f3c9ee954a27460dd865", [1, 2, 3, 4], ["a", "b", "c"], {from: account0, gas: 2000000});
'0xe68ea41c3f7333bfd1e121c903fac20e2a27324e6f130caea8b393d68c0294f2'

> MyXcertTokenInstance.tokenProof("1");
'4355a46b19d348dc2f57c046f8ef63d4538ebb936000f3c9ee954a27460dd865'

> MyXcertTokenInstance.tokenDataValue("1", 0);
'0x6100000000000000000000000000000000000000000000000000000000000000' // This is "a"

> MyXcertTokenInstance.tokenExpirationDate("1")
'0x1000000000000000000000000000000000000000000000000000000000000000'

// Set token data value at index 0 to date to Fri Jun  7 21:33:20 CEST 2024
> MyXcertTokenInstance.setTokenDataValue("1", 0, "1717788800", {from: account0});
'0x85bf59c60ee06b92600e16bde795fded18355b50481f3048d7b344abec2d57a5'

> MyXcertTokenInstance.tokenDataValue("1", 0);
'0x6663608000000000000000000000000000000000000000000000000000000000' // hex value of 1717788800

> MyXcertTokenInstance.balanceOf(account1).toString();
'1'

> MyXcertTokenInstance.burn("1", {from: account1, gas: 200000});
'0x2e5767595603e21a0e1ebdd6a7c3a05dd33b029e1b6e2594709580aa63fd290a'

> MyXcertTokenInstance.balanceOf(account1).toString();
'0'
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to help out.

## Licence

See [LICENSE](./LICENSE) for details.
