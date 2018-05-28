pragma solidity ^0.4.21;

import "./Xcert.sol";

contract RevokableXcert is Xcert {

  constructor(string _name, string _symbol, bytes4 _convention)
    Xcert(_name, _symbol, _convention)
    public
  {
    supportedInterfaces[0x20c5429b] = true; // RevokableXcert
  }

  /**
   * @dev Revokes a specified NFT.
   * @param _tokenId Id of the NFT we want to revoke.
   */
  function revoke(uint256 _tokenId)
    validNFToken(_tokenId)
    onlyOwner
    external
  {
    address tokenOwner = idToOwner[_tokenId];
    super._burn(tokenOwner, _tokenId);
    delete data[_tokenId];
    delete config[_tokenId];
    delete idToProof[_tokenId];
  }
}