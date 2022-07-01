// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "lib/forge-std/src/console.sol";
import "../src/ChocoMint.sol";

contract ChocoMintTest is Test {
    function setUp() public {}

    function testExecute() public {
        // Test on mint of PieceOfShit NFT collection
        uint256 mintPerAddress = 2; // mint 2 free per address
        uint256 value = 0; // free mint no ether in this case
        address target = 0x9F9B2B8e268d06DC67F0f76627654b80e219e1d6; // pieceOfShit contract
        bytes memory payload = abi.encodeWithSignature("mint(uint32)", mintPerAddress); 
        uint256 loops = 100; // mint 100x2 = 200 total
        uint256 targetBlock = 14879473; // used for flashbots
        uint256 toCoinbase = 0; // none provided to miner
        ChocoMint chocoMint = new ChocoMint();
        chocoMint.execute(value, target, payload, loops, targetBlock, toCoinbase);
        assertEq(IERC721(target).balanceOf(address(this)), 200);
    }
}
