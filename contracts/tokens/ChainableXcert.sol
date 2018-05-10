pragma solidity ^0.4.21;

import "./Xcert.sol";

contract ChainableXcert is Xcert {

  /*
   * @dev This emits when additional proof is chained.
   */
  event ChainedProof(uint256 indexed tokenId, uint256 proofIndex);

  constructor(string _name,
             string _symbol)
    Xcert(_name, _symbol)
    public
  {
    supportedInterfaces[0x6ea3dd92] = true; // ChainableXcert
  }

  /*
   * @dev Adds new proof to chain of proofs for token.
   * @param _tokenId Id of Xcert that we want to add proof to.
   * @param _proof New proof we want to add to NFToken.
   */
  function chain(uint256 _tokenId,
                 string _proof)
    validNFToken(_tokenId)
    onlyOwner
    external
  {

    require(bytes(_proof).length > 0);

    idToProof[_tokenId].push(_proof);

    emit ChainedProof(_tokenId, idToProof[_tokenId].length.sub(1));
  }

  /*
   * @dev Gets proof by index.
   * @param _tokenId Id of the Xcert we want to get proof of.
   * @param _index Index of the proof we want to get.
   */
  function tokenProofByIndex(uint256 _tokenId,
                           uint256 _index)
    validNFToken(_tokenId)
    external
    view
    returns (string)
  {
    require(_index < idToProof[_tokenId].length);
    return idToProof[_tokenId][_index];
  }

  /*
   * @dev Gets the count of all proofs for a Xcert.
   * @param _tokenId Id of the Xcert we want to get proof of.
   */
  function tokenProofCount(uint256 _tokenId)
    validNFToken(_tokenId)
    external
    view
    returns (uint256)
  {
    return idToProof[_tokenId].length;
  }

}