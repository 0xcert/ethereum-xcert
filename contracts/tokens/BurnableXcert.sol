pragma solidity ^0.4.23;

import "./Xcert.sol";

/**
 * @dev Xcert implementation where tokens can be destroyed by the owner or operator.
 */
contract BurnableXcert is Xcert {

  /**
   * @dev Contract constructor.
   * @param _name A descriptive name for a collection of NFTs.
   * @param _symbol An abbreviated name for NFT.
   * @param _conventionId A bytes4 of keccak256 of json schema representing 0xcert protocol
   * convention.
   */
  constructor(
    string _name,
    string _symbol,
    bytes4 _conventionId
  )
    Xcert(_name, _symbol, _conventionId)
    public
  {
    supportedInterfaces[0x42966c68] = true; // BurnableXcert
  }

  /**
   * @dev Burns a specified NFT.
   * @param _tokenId Id of the NFT we want to burn.
   */
  function burn(
    uint256 _tokenId
  )
    canOperate(_tokenId)
    validNFToken(_tokenId)
    external
  {
    super._burn(msg.sender, _tokenId);
    delete data[_tokenId];
    delete config[_tokenId];
    delete idToProof[_tokenId];
  }
}