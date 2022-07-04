// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Constants {
    
    /**
     * INITIAL SETUP ONLY
     */
    // Owner contract address
    address public OWNER = address(0);
    // ChocoMint contract address
    address public CHOCOMINT = address(0);
    // Implementation contract address
    address public IMPLEMENTATION_USER = address(0);
    // Proxie addresses. Add after creation.
    address[] public PROXIES;
    // Number of proxies to create.
    uint256 public PROXIE_LIMIT = 10;


    /**
     * EDIT FOR EACH SPECIFIC MINT
     */
    // Set these to deploy a specific mint
    address public MINT_ADDRESS = address(0);
    // Signiture of the minting function
    string public MINT_FUNCTION_SIGNATURE = "mint(uint256)";
    // Specify parameters for the minting function
    bytes public MINT_PAYLOAD = abi.encodeWithSignature(MINT_FUNCTION_SIGNATURE, 1);
    // Numbers of times to call the mint function by different proxies
    uint256 public MINT_COUNT = 1;
    // Eth for a single minting call
    uint256 public VALUE_PER_MINT = 0 ether;
    // Specific blocknumber to allow mint (flashbots only), default 0 for no specific block requirement
    uint256 public BLOCK_NUMBER = 0;
    // Eth to send to coinbase address (flashbots only)
    uint256 public TO_COINBASE = 0 ether;


    /**
     * AUTOMATICALLY GENERATED (DO NOT EDIT)
     */
    uint256 public PROXIE_COUNT = PROXIES.length;
     // Total eth to send to chocomint for all mints and miner tip
    uint256 public TOTAL_VALUE = VALUE_PER_MINT*MINT_COUNT + TO_COINBASE;
}