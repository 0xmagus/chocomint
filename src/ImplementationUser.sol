// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console2.sol";

interface IERC721 {
  function balanceOf(address owner) external view returns (uint256);
  function ownerOf(uint256) external view returns (address);
  function totalSupply() external view returns (uint256);
  function transferFrom(address from, address to, uint256 tokenId) external;
}

/**
 * ASSUMPTIONS
 * 1. Assumes ids in collection are minted in order
 * 2. Start Id must begin with id=0 or id=1
 * 3. Will work for collections that us _mint or _safeMint
 * 4. Does not work for collections that require msg.sender !== tx.origin 
 */
contract ImplementationUser {
    uint256 private startId;

    function mint(address _target, address payable _owner, bytes calldata _payload) external payable {
        startId = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (bool _success, bytes memory _response) = _target.call{value: msg.value}(_payload);
        require(_success); _response;
        IERC721 token = IERC721(_target);
        uint256 count = token.balanceOf(address(this));
        require(count > 0);

        uint256 _startId = startId;
        if (_startId == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) {
            _startId = token.totalSupply() - count;
            if(token.ownerOf(_startId) != address(this)) {
                unchecked {++_startId;}
            }
        }
        for (uint256 i = 0; i < count;) {
            token.transferFrom(address(this), _owner, _startId+i);
            unchecked {++i;}
        }
        if (address(this).balance > 1000000 gwei) {
            _owner.transfer(address(this).balance - 1);
        } 
    }
}