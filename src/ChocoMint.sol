// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./ProxyUser.sol";
import "forge-std/console2.sol";

contract ChocoMint {
    address private immutable owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProxy(uint256 amount)
        external
        onlyOwner
        returns (address[] memory)
    {
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
    ) external payable onlyOwner {
        require(_targetBlock == block.number || _targetBlock == 0);
        uint256 loops = proxies.length;
        for (uint256 i = 0; i < loops; ) {
            (bool _success, bytes memory _response) = proxies[i].call{
                value: _value
            }(_payload);
            require(_success);
            _response;
            unchecked {
                ++i;
            }
        }
        require(address(this).balance >= _toCoinbase);
        if (_toCoinbase > 0) {
            block.coinbase.transfer(_toCoinbase);
        }
        if (address(this).balance > 0) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }
}
