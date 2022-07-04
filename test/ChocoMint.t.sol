// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/ChocoMint.sol";
import "../src/ImplementationUser.sol";

contract ChocoMintTest is Test {
    ChocoMint public chocoMint;

    function setUp() public {
        chocoMint = new ChocoMint();
        vm.deal(address(this), 1 ether);
        vm.deal(address(chocoMint), 0);
        vm.deal(address(block.coinbase), 0);
    }

    function testCreateProxy() public {
        address[] memory proxies = chocoMint.createProxy(1);
        assertEq(proxies.length, 1);
    }

    function testExecuteMassMint() public {
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

    function testFailWrongBlock() public {
        address[] memory proxies = new address[](0);
        uint256 targetBlock = 1;

        chocoMint.execute(0, "", proxies, targetBlock, 0);
    }

    function testCoinbaseTransfer() public {
        address[] memory proxies = new address[](0);
        uint256 prevCoinbaseBalance = block.coinbase.balance;

        chocoMint.execute{value: 1 ether}(0, "", proxies, 0, 1 ether);
        assertEq(block.coinbase.balance - prevCoinbaseBalance, 1 ether);
    }

    function testFailNotEnoughEthToCoinbase() public {
        address[] memory proxies = new address[](0);

        chocoMint.execute(0, "", proxies, 0, 1 ether);
    }

    function testReturnsLeftOverEth() public {        
        address[] memory proxies = new address[](0);

        chocoMint.execute{value: 1 ether}(0, "", proxies, 0, 0);
        assertEq(address(this).balance, 1 ether);
    }

    receive() external payable {}
}