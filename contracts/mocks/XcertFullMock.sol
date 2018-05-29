pragma solidity ^0.4.23;

import "../../contracts/tokens/BurnableXcert.sol";
import "../../contracts/tokens/PausableXcert.sol";
import "../../contracts/tokens/RevokableXcert.sol";

contract XcertFullMock is BurnableXcert, PausableXcert, RevokableXcert {

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
    isPaused = false; //set the default pause state
  }
}
