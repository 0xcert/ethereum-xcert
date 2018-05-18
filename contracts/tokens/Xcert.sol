pragma solidity ^0.4.23;

import "../../node_modules/@0xcert/ethereum-erc721/contracts/math/SafeMath.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/ownership/Ownable.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/tokens/NFTokenMetadata.sol";
import "../../node_modules/@0xcert/ethereum-erc721/contracts/utils/AddressUtils.sol";

/*
 * @dev Xcert implementation.
 */
contract Xcert is NFTokenMetadata {
  using SafeMath for uint256;
  using AddressUtils for address;

  /*
   * @dev Maps NFT ID to proof.
   * @notice The Proof array for every token must include one or more items.
   */
  mapping (uint256 => string[]) internal idToProof;

  /*
   * @dev Maps authorized addresses to mint.
   */
  mapping (address => bool) internal addressToMintAuthorized;

  /*
   * @dev Emits when an address is authorized to mint new NFT or the authorization is revoked.
   * The _target can mint new NFTokens.
   * @param _target Address to set authorized state.
   * @patam _authorized True if the _target is authorised, false to revoke authorization.
   */
  event MintAuthorizedAddress(
    address indexed _target,
    bool _authorized
  );

  /*
   * @dev Guarantees that msg.sender is allowed to mint a new NFT.
   */
  modifier canMint() {
    require(msg.sender == owner || addressToMintAuthorized[msg.sender]);
    _;
  }

  /*
   * @dev Contract constructor.
   * @param _name A descriptive name for a collection of NFTs.
   * @param _symbol An abbreviated name for NFT.
   */
  constructor(
    string _name,
    string _symbol
  )
    NFTokenMetadata(_name, _symbol)
    public
  {
    supportedInterfaces[0x355d09e9] = true; // Xcert
  }

  /*
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   * @param _id The NFT to be minted by the msg.sender.
   * @param _proof Cryptographic asset imprint.
   * @param _uri An URI pointing to NFT metadata (optional, max length 2083).
   */
  function mint(
    address _to,
    uint256 _id,
    string _proof,
    string _uri
  )
    external
    canMint()
  {
    require(bytes(_proof).length > 0);
    super._mint(_to, _id);
    super._setTokenUri(_id, _uri);
    idToProof[_id].push(_proof);
  }

  /*
   * @dev Gets proof for NFT token.
   * @param _tokenId Id of the NFT.
   */
  function tokenProof(
    uint256 _tokenId
  )
    validNFToken(_tokenId)
    external
    view
    returns (string)
  {
    return idToProof[_tokenId][idToProof[_tokenId].length.sub(1)];
  }

  /*
   * @dev Sets authorised address for minting.
   * @param _target Address to set authorized state.
   * @patam _authorized True if the _target is authorised, false to revoke authorization.
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

  /*
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
