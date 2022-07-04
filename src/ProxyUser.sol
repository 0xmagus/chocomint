// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

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

    function onERC721Received(address, address, uint256 id, bytes calldata) external returns (bytes4) {
        assembly {
            if eq(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, sload(0)) {
                sstore(0x0, id)
            }
        }
        return 0x150b7a02;
    }

    receive() external payable {}
}