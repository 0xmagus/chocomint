// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/console2.sol";

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

contract ProxyUser {
    uint256 private startId;

    fallback() external payable {
        assembly {
            let target := calldataload(0x0)
            let freememstart := mload(0x40)
            calldatacopy(freememstart, 32, sub(calldatasize(), 32))
            let success := delegatecall(gas(), target, freememstart, sub(calldatasize(), 32), 0x40, 32)
            returndatacopy(0x0, 0x0, returndatasize())
            switch success case 0 {revert(0, 0)} default {return (0, returndatasize())}
        }
    }

    receive() external payable{}

    function onERC721Received(address, address, uint256 id, bytes calldata) external returns (bytes4) {
        assembly {
            if eq(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, sload(0)) {
                sstore(0x0, id)
            }
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

    function createProxy(uint256 amount) external onlyOwner returns (address[] memory) {
        address[] memory proxyAddresses = new address[](amount);
        for (uint256 i = 0; i < amount; i++) {
            proxyAddresses[i] = address(new ProxyUser());
        }
        return proxyAddresses;
    }

    function execute(
        uint256 _value, 
        bytes calldata _payload,
        address[] calldata proxies,
        uint256 _targetBlock,
        uint256 _toCoinbase
    ) external onlyOwner payable {
        require(_targetBlock == block.number || _targetBlock == 0);
        uint256 loops = proxies.length;
        for (uint256 i = 0; i < loops;) {
            (bool _success, bytes memory _response) = proxies[i].call{value: _value}(_payload);
            require(_success); _response;
            unchecked {++i;}
        }
        if (_toCoinbase > 0) {
            block.coinbase.transfer(_toCoinbase);
        }
    }
}
