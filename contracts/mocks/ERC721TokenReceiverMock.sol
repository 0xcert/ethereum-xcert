pragma solidity ^0.4.23;

import "../../contracts/tokens/ERC721TokenReceiver.sol";


contract ERC721TokenReceiverMock is ERC721TokenReceiver {

  /*
   * @dev Magic value of a smart contract that can recieve NFToken.
   */
  bytes4 private constant MAGIC_ONERC721RECEIVED = bytes4(
    keccak256("onERC721Received(address,uint256,bytes)")
  );

  /*
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `transfer`. This function MAY throw to revert and reject the
   * transfer. This function MUST use 50,000 gas or less. Return of other
   * than the magic value MUST result in the transaction being reverted.
   *  Note: the contract address is always the message sender.
   * @param _from The sending address
   * @param _tokenId The NFT identifier which is being transfered
   * @param data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
   *  unless throwing
   */
  function onERC721Received(address _from,
                            uint256 _tokenId,
                            bytes data)
    external
    returns(bytes4)
  {
    _from;
    _tokenId;
    data;
    return MAGIC_ONERC721RECEIVED;
  }
}