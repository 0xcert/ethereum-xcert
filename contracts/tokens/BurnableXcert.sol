pragma solidity ^0.4.23;

import "./Xcert.sol";

contract BurnableXcert is Xcert {

  constructor(string _name,
              string _symbol,
              bytes4 _convention)
    Xcert(_name, _symbol, _convention)
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
    delete data[_tokenId];
    delete config[_tokenId];
    delete idToProof[_tokenId];
  }
}