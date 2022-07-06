// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ImplementationUser.sol";
import "../src/ProxyUser.sol";

contract ProxyUserTest is Test {

    function setUp() public {}

    function testProxyUserFallback() public {
        address impUser = address(new ImplementationUser());
        address proxy = address(new ProxyUser());

        address mintTarget = 0x9F9B2B8e268d06DC67F0f76627654b80e219e1d6; // pieceOfShit contract
        bytes memory mintPayload = abi.encodeWithSignature("mint(uint32)", 1); // mint 1
        bytes memory impPayload = abi.encodeWithSignature(
            "mint(address,address,bytes)", 
            mintTarget, 
            address(this),
            mintPayload);
        bytes memory proxyPayload = abi.encodePacked(abi.encode(impUser), impPayload);

        (bool _success, bytes memory _response) = proxy.call(proxyPayload);
        assertTrue(_success); _response;
        assertEq(IERC721(mintTarget).balanceOf(address(this)), 1);
    }
}