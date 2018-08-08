pragma solidity ^0.4.24;

import "@0xcert/ethereum-utils/contracts/math/SafeMath.sol";
import "@0xcert/ethereum-utils/contracts/ownership/Claimable.sol";
import "@0xcert/ethereum-utils/contracts/utils/AddressUtils.sol";
import "@0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol";
import "@0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol";

/**
 * @dev Xcert implementation.
 */
contract Xcert is NFTokenEnumerable, NFTokenMetadata, Claimable {
  using SafeMath for uint256;
  using AddressUtils for address;

  /**
   * @dev Unique ID which determines each Xcert smart contract type by its JSON convention.
   * @notice Calculated as bytes4(keccak256(jsonSchema)).
   */
  bytes4 internal nftConventionId;

  /**
   * @dev Maps NFT ID to proof.
   */
  mapping (uint256 => string) internal idToProof;

  /**
   * @dev Maps NFT ID to protocol config.
   */
  mapping (uint256 => bytes32[]) internal config;

  /**
   * @dev Maps NFT ID to convention data.
   */
  mapping (uint256 => bytes32[]) internal data;

  /**
   * @dev Maps address to authorization of contract.
   */
  mapping (address => bool) internal addressToAuthorized;

  /**
   * @dev Emits when an address is authorized to some contract control or the authorization is revoked.
   * The _target has some contract controle like minting new NFTs.
   * @param _target Address to set authorized state.
   * @param _authorized True if the _target is authorised, false to revoke authorization.
   */
  event AuthorizedAddress(
    address indexed _target,
    bool _authorized
  );

  /**
   * @dev Guarantees that msg.sender is allowed to mint a new NFT.
   */
  modifier isAuthorized() {
    require(msg.sender == owner || addressToAuthorized[msg.sender]);
    _;
  }

  /**
   * @dev Contract constructor.
   * @notice When implementing this contract don't forget to set nftConventionId, nftName and
   * nftSymbol.
   */
  constructor()
    public
  {
    supportedInterfaces[0x6be14f75] = true; // Xcert
  }

  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   * @param _id The NFT to be minted by the msg.sender.
   * @param _uri An URI pointing to NFT metadata.
   * @param _proof Cryptographic asset imprint.
   * @param _config Array of protocol config values where 0 index represents token expiration
   * timestamp, other indexes are not yet definied but are ready for future xcert upgrades.
   * @param _data Array of convention data values.
   */
  function mint(
    address _to,
    uint256 _id,
    string _uri,
    string _proof,
    bytes32[] _config,
    bytes32[] _data
  )
    external
    isAuthorized()
  {
    require(_config.length > 0);
    require(bytes(_proof).length > 0);
    super._mint(_to, _id);
    super._setTokenUri(_id, _uri);
    idToProof[_id] = _proof;
    config[_id] = _config;
    data[_id] = _data;
  }

  /**
   * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert protocol convention.
   */
  function conventionId()
    external
    view
    returns (bytes4 _conventionId)
  {
    _conventionId = nftConventionId;
  }

  /**
   * @dev Returns proof for NFT.
   * @param _tokenId Id of the NFT.
   */
  function tokenProof(
    uint256 _tokenId
  )
    validNFToken(_tokenId)
    external
    view
    returns(string)
  {
    return idToProof[_tokenId];
  }

  /**
   * @dev Returns convention data value for a given index field.
   * @param _tokenId Id of the NFT we want to get value for key.
   * @param _index for which we want to get value.
   */
  function tokenDataValue(
    uint256 _tokenId,
    uint256 _index
  )
    validNFToken(_tokenId)
    public
    view
    returns(bytes32 value)
  {
    require(_index < data[_tokenId].length);
    value = data[_tokenId][_index];
  }

  /**
   * @dev Returns expiration date from 0 index of token config values.
   * @param _tokenId Id of the NFT we want to get expiration time of.
   */
  function tokenExpirationTime(
    uint256 _tokenId
  )
    validNFToken(_tokenId)
    external
    view
    returns(bytes32)
  {
    return config[_tokenId][0];
  }

  /**
   * @dev Sets authorised address for minting.
   * @param _target Address to set authorized state.
   * @param _authorized True if the _target is authorised, false to revoke authorization.
   */
  function setAuthorizedAddress(
    address _target,
    bool _authorized
  )
    onlyOwner
    external
  {
    require(_target != address(0));
    addressToAuthorized[_target] = _authorized;
    emit AuthorizedAddress(_target, _authorized);
  }

  /**
   * @dev Sets mint authorised address.
   * @param _target Address for which we want to check if it is authorized.
   * @return Is authorized or not.
   */
  function isAuthorizedAddress(
    address _target
  )
    external
    view
    returns (bool)
  {
    require(_target != address(0));
    return addressToAuthorized[_target];
  }
}
