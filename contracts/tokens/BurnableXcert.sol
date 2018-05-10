pragma solidity ^0.4.23;

import "./Xcert.sol";

contract BurnableXcert is Xcert {

  constructor(string _name,
              string _symbol)
    Xcert(_name, _symbol)
    public
  {
    supportedInterfaces[0x42966c68] = true; // BurnableXcert
  }

  /*
   * @dev Burns a specified NFToken.
   * @param _tokenId Id of the NFToken we want to burn.
   */
  function burn(uint256 _tokenId)
    canOperate(_tokenId)
    validNFToken(_tokenId)
    external
  {
    super._burn(msg.sender, _tokenId);
    delete idToProof[_tokenId];
  }

}