// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/ChocoMint.sol";
import "../src/ImplementationUser.sol";

contract ChocoMintTest is Test {
    Vm public VM;

    function setUp() public {
        VM = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    }

    function testExecute() public {
        ChocoMint chocoMint = new ChocoMint();
        address impUser = address(new ImplementationUser());
        address[] memory proxies = chocoMint.createProxy(100);

        // Test on mint of PieceOfShit NFT collection
        uint256 value = 0; // free mint no ether in this case
        address mintTarget = 0x9F9B2B8e268d06DC67F0f76627654b80e219e1d6; // pieceOfShit contract
        bytes memory mintPayload = abi.encodeWithSignature("mint(uint32)", 2); 
        bytes memory impPayload = abi.encodeWithSignature(
            "mint(address,address,bytes)", 
            mintTarget, 
            address(this),
            mintPayload);
        bytes memory proxyPayload = abi.encodePacked(abi.encode(address(impUser)), impPayload);

        uint256 targetBlock = 14879473; // used for flashbots to prevent uncled tx to get confirmed
        uint256 toCoinbase = 0; // none provided to miner

        chocoMint.execute(value, proxyPayload, proxies, targetBlock, toCoinbase);
        assertEq(IERC721(mintTarget).balanceOf(address(this)), 200);
    }

    function testCreateProxy() public {
        ChocoMint chocoMint = new ChocoMint();
        address[] memory proxies = chocoMint.createProxy(1);
        assertEq(proxies.length, 1);
    }

    function testProxyUser() public {
        address impUser = address(new ImplementationUser());
        address proxy = address(new ProxyUser());

        address mintTarget = 0x9F9B2B8e268d06DC67F0f76627654b80e219e1d6; // pieceOfShit contract
        bytes memory mintPayload = abi.encodeWithSignature("mint(uint32)", 2); // mint 2
        bytes memory impPayload = abi.encodeWithSignature(
            "mint(address,address,bytes)", 
            mintTarget, 
            address(this),
            mintPayload);
        bytes memory proxyPayload = abi.encodePacked(abi.encode(impUser), impPayload);

        (bool _success, bytes memory _response) = proxy.call(proxyPayload);
        assertTrue(_success); _response;
        assertEq(IERC721(mintTarget).balanceOf(address(this)), 2);
    }
}