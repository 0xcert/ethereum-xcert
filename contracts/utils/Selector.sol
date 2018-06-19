pragma solidity ^0.4.24;

import "../tokens/Xcert.sol";
import "../tokens/BurnableXcert.sol";
import "../tokens/PausableXcert.sol";
import "../tokens/RevokableXcert.sol";
import "../tokens/MutableXcert.sol";

/**
 * @dev This contracts calculates interface id of Xcert contracts as described in EIP165:
 * http://tiny.cc/uo23ty.
 * @notice See test folder for usage examples.
 */
contract Selector {

  /**
   * @dev Calculates and returns interface ID for the Xcert smart contract.
   */
  function calculateXcertSelector()
    public
    pure
    returns (bytes4)
  {
    Xcert i;
    return (
      i.mint.selector
      ^ i.conventionId.selector
      ^ i.tokenProof.selector
      ^ i.tokenDataValue.selector
      ^ i.tokenExpirationTime.selector
      ^ i.setAuthorizedAddress.selector
      ^ i.isAuthorizedAddress.selector
    );
  }

  /**
   * @dev Calculates and returns interface ID for the BurnableXcert smart contract.
   */
  function calculateBurnableXcertSelector()
    public
    pure
    returns (bytes4)
  {
    BurnableXcert i;
    return i.burn.selector;
  }

  /**
   * @dev Calculates and returns interface ID for the PausableXcert smart contract.
   */
  function calculatePausableXcertSelector()
    public
    pure
    returns (bytes4)
  {
    PausableXcert i;
    return i.setPause.selector;
  }

  /**
   * @dev Calculates and returns interface ID for the RevokableXcert smart contract.
   */
  function calculateRevokableXcertSelector()
    public
    pure
    returns (bytes4)
  {
    RevokableXcert i;
    return i.revoke.selector;
  }

  /**
   * @dev Calculates and returns interface ID for the RevokableXcert smart contract.
   */
  function calculateMutableXcertSelector()
    public
    pure
    returns (bytes4)
  {
    MutableXcert i;
    return i.setTokenData.selector;
  }

}