pragma solidity ^0.4.23;

import "../../contracts/tokens/BurnableXcert.sol";
import "../../contracts/tokens/PausableXcert.sol";
import "../../contracts/tokens/RevokableXcert.sol";

contract XcertMock is BurnableXcert, PausableXcert, RevokableXcert {

  constructor(
    string _name,
    string _symbol,
    bytes4 _conventionId
  )
    public
    BurnableXcert(_name, _symbol, _conventionId)
    PausableXcert(_name, _symbol, _conventionId)
    RevokableXcert(_name, _symbol, _conventionId)
  {

  }

}
