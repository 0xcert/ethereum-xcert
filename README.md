<img src="https://github.com/0xcert/ethereum-xcert/raw/master/assets/cover.png" />

![Build Status](https://travis-ci.org/0xcert/ethereum-xcert.svg?branch=master)&nbsp;[![NPM Version](https://badge.fury.io/js/@0xcert%2Fethereum-xcert.svg)](https://badge.fury.io/js/0xcert%2Fethereum-xcert)&nbsp;[![Dependencies Status](https://david-dm.org/0xcert/ethereum-xcert.svg)](https://david-dm.org/0xcert/ethereum-xcert)&nbsp;[![Bug Bounty](https://img.shields.io/badge/bounty-pending-2930e8.svg)](https://github.com/0xcert/ethereum-xcert/issues/24)

> Xcert token implementation for the Ethereum blockchain.

This is the official implementation of the [Xcert](https://github.com/0xcert/0xcert/blob/981f05ffd366d085967bf99a6d24613e63e1c88e/specs/2.md) token for the Ethereum blockchain. This is an open source project build with [Truffle](http://truffleframework.com) framework.

Purpose of this implemetation is to provide a good starting point for anyone who wants to use and develop the low-level layer of the 0xcert protocol on the Ethereum blockchain. Instead of re-implementing the 0xcert specs yourself you can use this code which has gone through multiple audits and we hope it will be extensively used by the community in the future.

An Xcert is an extension of the [ERC-721](https://github.com/0xcert/ethereum-erc721/) implementation. It is an opinionated non-fungible token which carries a proof of a digital asset and supports additional 0xcert protocol features. You can read more about this in the official [0xcert protocol yellow paper](https://github.com/0xcert/whitepaper/blob/master/dist/0xcert-protocol.pdf).

<img src="https://github.com/0xcert/ethereum-xcert/raw/master/assets/diagram.png" />

## Structure

Since this is a Truffle project, you will find all tokens in `contracts/tokens/` directory. There are multiple implementations and you can select between:
- `Xcert.sol`: This is the base Xcert token implementation.
- `BurnableXcert.sol`: This implements optional support for token burning. It is useful if you want token owners to be able to burn them.
- `MutableXcert.sol`: This implements enables token data to be changed by authorized address.
- `PausableXcert.sol`: This implements optional freeze for token transfers. It is useful if you want to be able to pause all token transfers at any time.
- `RevokableXcert.sol`: This implements optional revoking mechanism. It is useful if you want to allow owner of the Xcert contract to revoke any token at any time.

## Installation

Requirements:
- NodeJS 9.0+ recommended.
- Windows, Linux or Mac OS X.

### NPM

This is an [NPM](https://www.npmjs.com/package/@0xcert/ethereum-xcert) module for [Truffle](http://truffleframework.com) framework. In order to use it as a dependency in your Javascript project, you must first install it through the `npm` command:

```
$ npm install @0xcert/ethereum-xcert
```

### Source

Clone the repository and install the required npm dependencies:

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

## Usage

### NPM

To interact with package's contracts within JavaScript code, you simply need to require that package's .json files:

```js
const contract = require("@0xcert/ethereum-xcert/build/contracts/Xcert.json");
console.log(contract);
```

### Source

The easiest way to start is to create a new file under contracts/tokens/ (e.g. MyXcertToken.sol):

```sol
pragma solidity ^0.4.23;

import "../tokens/BurnableXcert.sol";

contract MyXcertToken is BurnableXcert {

  constructor(
    string _name,
    string _symbol,
    bytes4 _conventionId
  )
    public
  {
    nftName = _name;
    nftSymbol = _symbol;
    nftConventionId = _conventionId;
  }

}
```

That's it. Let's compile the contract:

```
$ npm run compile
```

The easiest way to deploy it locally and start interacting with the contract (minting and transferring tokens) is to deploy it on your personal (local) blockchain using [Ganache](http://truffleframework.com/ganache/). Follow the steps in the Truffle documentation which are described [here](http://truffleframework.com/docs/getting_started/project#alternative-migrating-with-ganache).

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to help out.

## Licence

See [LICENSE](./LICENSE) for details.
