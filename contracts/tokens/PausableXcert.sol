pragma solidity ^0.4.21;

import "./Xcert.sol";

contract PausableXcert is Xcert {

  /**
   * @dev This emits when ability of beeing able to transfer NFTs changes (paused/unpaused).
   */
  event IsPaused(bool _isPaused);

  /**
   * @dev Are NFT paused or not.
   */
  bool public isPaused;

  constructor(string _name, string _symbol, bytes4 _convention)
    Xcert(_name, _symbol, _convention)
    public
  {
    supportedInterfaces[0xbedb86fb] = true; // PausableXcert
    isPaused = false;
  }

  /**
   * @dev Guarantees that the msg.sender is allowed to transfer NFT.
   * @param _tokenId ID of the NFT to transfer.
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

  /**
   * @dev Sets if NFTs are paused or not.
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