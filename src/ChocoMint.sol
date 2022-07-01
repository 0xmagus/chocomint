// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/console.sol";

interface IERC721 {
  function balanceOf(address owner) external view returns (uint256);
  function transferFrom(address from, address to, uint256 tokenId) external;
}

contract TempUser {
    // Assumes ids in collection are minted in order
    uint256 startId = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    function execute(address _target, bytes calldata _payload, address _owner) external payable {
        (bool _success, bytes memory _response) = _target.call{value: msg.value}(_payload);
        require(_success); _response;
        
        IERC721 token = IERC721(_target);
        uint256 count = token.balanceOf(address(this));
        for (uint256 i = 0; i < count;) {
            token.transferFrom(address(this), _owner, startId+i);
            unchecked {++i;}
        }

        selfdestruct(payable(_owner));
    }

    function onERC721Received(address, address, uint256 id, bytes calldata) external returns (bytes4) {
        if (startId == 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) {
            startId = id;
        }
        return 0x150b7a02;
    }
}

contract ChocoMint {
    address private immutable owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function execute(
        uint256 _value, 
        address _target,
        bytes calldata _payload, 
        uint256 loops, 
        uint256 _targetBlock, 
        uint256 _toCoinbase
    ) external onlyOwner payable {
        require(_targetBlock == block.number || _targetBlock == 0);

        for (uint256 i = 0; i < loops;) {
            new TempUser().execute{value: _value}(_target, _payload, owner);
            unchecked {++i;}
        }
        if (_toCoinbase > 0) {
            block.coinbase.transfer(_toCoinbase);
        }
    }
}
