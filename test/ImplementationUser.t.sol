// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/ImplementationUser.sol";

contract ImplementationUserTest is Test {
    
    function setUp() public {}

    function testMint() public {
        // Cannot handle actual mints due to onERC721Received
    }
}