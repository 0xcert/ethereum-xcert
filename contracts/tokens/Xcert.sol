pragma solidity ^0.4.23;

import "../../node_modules/@0xcert/ethereum-erc721/contracts/math/SafeMath.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/ownership/Ownable.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/tokens/NFTokenEnumerable.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/utils/AddressUtils.sol";

/**
 * @dev Xcert implementation.
 */
contract Xcert is NFTokenEnumerable, NFTokenMetadata {
  using SafeMath for uint256;
  using AddressUtils for address;

  /**
   * @dev A bytes4 of keccak256 of json schema representing 0xcert protocol convention.
   * @notice bytes4(keccak256(json)).
   */
  bytes4 private nftConvention;

  /**
   * @dev Maps NFT ID to proof.
   */
  mapping (uint256 => string) internal idToProof;

  /**
   * @dev Map of protocol data.
   */
  mapping (uint256 => bytes32[]) internal config;

  /**
   * @dev Map of convention data.
   */
  mapping (uint256 => bytes32[]) internal data;

  /**
   * @dev Maps authorized addresses to mint.
   */
  mapping (address => bool) internal addressToMintAuthorized;

  /**
   * @dev Emits when an address is authorized to mint new NFT or the authorization is revoked.
   * The _target can mint new NFTs.
   * @param _target Address to set authorized state.
   * @param _authorized True if the _target is authorised, false to revoke authorization.
   */
  event MintAuthorizedAddress(
    address indexed _target,
    bool _authorized
  );

  /**
   * @dev Guarantees that msg.sender is allowed to mint a new NFT.
   */
  modifier canMint() {
    require(msg.sender == owner || addressToMintAuthorized[msg.sender]);
    _;
  }

  /**
   * @dev Contract constructor.
   * @param _name A descriptive name for a collection of NFTs.
   * @param _symbol An abbreviated name for NFT.
   * @param _convention A bytes4 of keccak256 of json schema representing 0xcert protocol
   * convention.
   */
  constructor(
    string _name,
    string _symbol,
    bytes4 _convention
  )
    NFTokenMetadata(_name, _symbol)
    public
  {
    nftConvention = _convention;
    supportedInterfaces[0xe353dea7] = true; // Xcert
  }

  /**
   * @dev Mints a new NFT.
   * @notice _dataKey and _dataValue length has to be the same.
   * @param _to The address that will own the minted NFT.
   * @param _id The NFT to be minted by the msg.sender.
   * @param _uri An URI pointing to NFT metadata.
   * @param _proof Cryptographic asset imprint.
   * @param _config Array of config values.
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
    canMint()
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
  function convention()
    external
    view
    returns (bytes4 _convention)
  {
    _convention = nftConvention;
  }

  /**
   * @dev Gets proof for NFT.
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
   * @dev Sets value for specified key.
   * @param _tokenId Id of the NFT we want to set key value data.
   * @param _index for which we want to set value.
   * @param _value that we want to set.
   */
  function setTokenDataValue(
    uint256 _tokenId,
    uint256 _index,
    bytes32 _value
  )
    onlyOwner
    validNFToken(_tokenId)
    external
  {
    require(_index < data[_tokenId].length);
    data[_tokenId][_index] = _value;
  }

  /**
   * @dev Gets value of key for specific NFT.
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
   * @dev Gets expiration date from config values.
   * @param _tokenId Id of the NFT we want to get expiration date of.
   */
  function tokenExpirationDate(
    uint256 _tokenId
  )
    validNFToken(_tokenId)
    external
    returns(bytes32)
  {
    return config[_tokenId][0];
  }

  /**
   * @dev Sets authorised address for minting.
   * @param _target Address to set authorized state.
   * @param _authorized True if the _target is authorised, false to revoke authorization.
   */
  function setMintAuthorizedAddress(
    address _target,
    bool _authorized
  )
    external
    onlyOwner
  {
    require(_target != address(0));
    addressToMintAuthorized[_target] = _authorized;
    emit MintAuthorizedAddress(_target, _authorized);
  }

  /**
   * @dev Sets mint authorised address.
   * @param _target Address for which we want to check if it is authorized.
   * @return Is authorized or not.
   */
  function isMintAuthorizedAddress(
    address _target
  )
    external
    view
    returns (bool)
  {
    require(_target != address(0));
    return addressToMintAuthorized[_target];
  }
}
