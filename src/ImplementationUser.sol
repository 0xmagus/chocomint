// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC721 {
  function balanceOf(address owner) external view returns (uint256);
  function transferFrom(address from, address to, uint256 tokenId) external;
}

// Assumes ids in collection are minted in order
contract ImplementationUser {
    uint256 private startId;

    function mint(address _target, address payable _owner, bytes calldata _payload) external payable {
        startId = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (bool _success, bytes memory _response) = _target.call{value: msg.value}(_payload);
        require(_success); _response;
        IERC721 token = IERC721(_target);
        uint256 count = token.balanceOf(address(this));
        for (uint256 i = 0; i < count;) {
            token.transferFrom(address(this), _owner, startId+i);
            unchecked {++i;}
        }
        if (address(this).balance > 0) {
            _owner.transfer(address(this).balance);
        } 
    }
}