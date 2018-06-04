pragma solidity ^0.4.24;

import "./Xcert.sol";

/**
 * @dev Xcert implementation where tokens can be destroyed by the issuer.
 */
contract RevokableXcert is Xcert {

  /**
   * @dev Contract constructor.
   * @notice When implementing this contract don't forget to set nftConventionId, nftName and
   * nftSymbol.
   */
  constructor()
    public
  {
    supportedInterfaces[0x20c5429b] = true; // RevokableXcert
  }

  /**
   * @dev Revokes a specified NFT.
   * @param _tokenId Id of the NFT we want to revoke.
   */
  function revoke(
    uint256 _tokenId
  )
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