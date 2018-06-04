pragma solidity ^0.4.24;

import "./Xcert.sol";

/**
 * @dev Xcert implementation where token data can be changed by authorized address.
 */
contract MutableXcert is Xcert {

  /**
   * @dev Emits when an Token data is changed.
   * @param _id NFT that data got changed.
   * @param _data New data.
   */
  event TokenDataChange(
    uint256 indexed _id,
    bytes32[] _data
  );

  /**
   * @dev Contract constructor.
   * @notice When implementing this contract don't forget to set nftConventionId, nftName and
   * nftSymbol.
   */
  constructor()
    public
  {
    supportedInterfaces[0x59118221] = true; // MutableXcert
  }

  /**
   * @dev Modifies convention data by setting a new value for a given index field.
   * @param _tokenId Id of the NFT we want to set key value data.
   * @param _data New token data.
   */
  function setTokenData(
    uint256 _tokenId,
    bytes32[] _data
  )
    validNFToken(_tokenId)
    isAuthorized()
    external
  {
    data[_tokenId] = _data;
    emit TokenDataChange(_tokenId, _data);
  }
}