// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/ChocoMint.sol";
import "../src/ImplementationUser.sol";
import "./Constants.s.sol";

contract DeployChocoMint is Script {
    function run() external {
        Constants constants = new Constants();
        require(constants.CHOCOMINT() == address(0), "ChocoMint already deployed");

        vm.startBroadcast();
        ChocoMint chocoMint = new ChocoMint();
        vm.stopBroadcast();
        console2.log("ChocoMint contract deployed at: ", address(chocoMint));
    }
}

contract DeployImplementationUser is Script {
    function run() external {
        Constants constants = new Constants();
        require(constants.IMPLEMENTATION_USER() == address(0), "ImplementationUser already deployed");

        vm.startBroadcast();
        ImplementationUser impUser = new ImplementationUser();
        vm.stopBroadcast();
        console2.log("ImplementationUser contract deployed at: ", address(impUser));
    }
}

contract DeployProxyUsers is Script {
    function run() external {
        Constants constants = new Constants();

        require(constants.CHOCOMINT() != address(0), "ChocoMint contract not created");
        uint256 proxiesToCreate = constants.PROXIE_LIMIT() - constants.PROXIE_COUNT();
        require(proxiesToCreate > 0, "Proxy limit has been reached");
        
        vm.startBroadcast();
        address[] memory proxies = ChocoMint(constants.CHOCOMINT()).createProxy(proxiesToCreate);
        vm.stopBroadcast();
        console2.log("ProxyUser contracts deployed at:");
        for (uint256 i = 0; i < proxies.length; i++) {
            console2.log(proxies[i]);
        }
    }
}

contract Mint is Script {
    function run() external {
        Constants constants = new Constants();
        uint256 mintCount = constants.MINT_COUNT();

        require(constants.OWNER() != address(0), "Invalid owner specified");
        require(constants.CHOCOMINT() != address(0), "ChocoMint contract not created");
        require(constants.IMPLEMENTATION_USER() != address(0),  "ImplementationUser contract not created");
        require(constants.PROXIE_COUNT() >= mintCount, "Not enough proxy contracts to satisfy mint count");
        require(constants.VALUE_PER_MINT()*mintCount <= constants.TOTAL_VALUE(), "Not enough ETH for all mints");

        address mintTarget = constants.MINT_ADDRESS();
        bytes memory mintPayload = constants.MINT_PAYLOAD();
        // Payload to implementation user.
        bytes memory impPayload = abi.encodeWithSignature(
            "mint(address,address,bytes)", 
            mintTarget,
            constants.OWNER(),
            mintPayload);
        // Payload to proxy user.
        bytes memory proxyPayload = abi.encodePacked(abi.encode(constants.IMPLEMENTATION_USER()), impPayload);
        // Copy the proxy addresses based on number of proxies to mint.
        address[] memory proxies = new address[](mintCount);
        for (uint256 i = 0; i < mintCount; i++) {
            proxies[i] = constants.PROXIES(i);
        }

        vm.startBroadcast();
        ChocoMint(constants.CHOCOMINT())
            .execute{value: constants.TOTAL_VALUE()}(
                constants.VALUE_PER_MINT(), 
                proxyPayload,
                proxies, 
                constants.BLOCK_NUMBER(), 
                constants.TO_COINBASE());
        vm.stopBroadcast();
    }
}