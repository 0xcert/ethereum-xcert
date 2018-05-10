pragma solidity ^0.4.21;

import "./Xcert.sol";

contract RevokableXcert is Xcert {

  constructor(string _name, string _symbol)
    Xcert(_name, _symbol)
    public
  {
    supportedInterfaces[0x20c5429b] = true; // RevokableXcert
  }

  /*
   * @dev Revokes a specified NFToken.
   * @param _tokenId Id of the NFToken we want to revoke.
   */
  function revoke(uint256 _tokenId)
    validNFToken(_tokenId)
    onlyOwner
    external
  {
    address tokenOwner = idToOwner[_tokenId];
    if (getApproved(_tokenId) != 0) {
      clearApproval(tokenOwner, _tokenId);
    }

    removeNFToken(tokenOwner, _tokenId);
    delete idToUri[_tokenId];
    delete idToProof[_tokenId];

    emit Transfer(owner, address(0), _tokenId);
  }
}