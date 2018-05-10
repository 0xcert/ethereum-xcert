pragma solidity ^0.4.21;

import "./Xcert.sol";

contract PausableXcert is Xcert {

  /*
   * @dev This emits when ability of beeing able to transfer NFTokens changes (paused/unpaused).
   */
  event IsPaused(bool _isPaused);

  /*
   * @dev Are NFTokens paused or not.
   */
  bool public isPaused;

  constructor(string _name, string _symbol)
    Xcert(_name, _symbol)
    public
  {
    supportedInterfaces[0xbedb86fb] = true; // PausableXcert
    isPaused = false;
  }

  /*
   * @dev Guarantees that the msg.sender is allowed to transfer NFToken.
   * @param _tokenId ID of the NFToken to transfer.
   */
  modifier canTransfer(uint256 _tokenId) {
    address owner = idToOwner[_tokenId];
    require(!isPaused && (
      owner == msg.sender
      || getApproved(_tokenId) == msg.sender
      || ownerToOperators[owner][msg.sender])
    );

    _;
  }

  /*
   * @dev Sets if NFTokens are paused or not.
   * @param _isPaused Pause status.
   */
  function setPause(bool _isPaused)
    external
    onlyOwner
  {
    require(isPaused != _isPaused);
    isPaused = _isPaused;
    emit IsPaused(_isPaused);
  }

}