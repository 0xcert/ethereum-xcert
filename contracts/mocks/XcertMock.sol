pragma solidity ^0.4.23;

import "../../contracts/tokens/BurnableXcert.sol";
import "../../contracts/tokens/PausableXcert.sol";
import "../../contracts/tokens/RevokableXcert.sol";

contract XcertMock is BurnableXcert, PausableXcert, RevokableXcert {

  constructor(
    string _name,
    string _symbol
  )
    public
    BurnableXcert(_name, _symbol)
    PausableXcert(_name, _symbol)
    RevokableXcert(_name, _symbol)
  {

  }

}
