pragma solidity ^0.4.23;

import "../../contracts/tokens/BurnableXcert.sol";
import "../../contracts/tokens/PausableXcert.sol";
import "../../contracts/tokens/ChainableXcert.sol";
import "../../contracts/tokens/RevokableXcert.sol";

contract XcertMock is BurnableXcert, PausableXcert, ChainableXcert, RevokableXcert {

constructor(string _name, string _symbol)
    BurnableXcert(_name, _symbol)
    PausableXcert(_name, _symbol)
    ChainableXcert(_name, _symbol)
    RevokableXcert(_name, _symbol)
    public
  {

  }
}