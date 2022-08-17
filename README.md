# Chocomint

Creates proxy users to circumvent public mint limits.

## Disclaimer

Use at your own risk. There are no warranties with this project. Keep in mind mass minting may go
against the spirit of supporting a project.

## Quickstart

Install foundry following thse instructions:
https://book.getfoundry.sh/getting-started/installation.html

```
forge init
forge build
```

Follow deploy steps to launch contract and set up proxy users.

## Assumptions

1. Assumes ids in collection are minted in order
2. Start Id must begin with id=0 or id=1
3. Will work for collections that use \_mint or \_safeMint
4. Does not work for collections that require msg.sender !== tx.origin

## Safeguards

Minting with this tool will perform a simulation prior to sending out the mass mint tx. Therefore rest easy that you
will likely not get reverts as long as theres supply left.

## Integration Testing on Mainnet

Testing on mainnet is done at a previous block to simulate valid order. Make sure MAIN_RPC_URL is to an archive node.
Recommend using alchemy endpoint.

```
source .env && forge test --fork-url $MAIN_RPC_URL --fork-block-number 14879473 -vvvv --gas-report
```

## Deploy Instructions

Operate on root project directory. Requires eth in the user account for gas. If testnet get eth with a faucet.

### 1. Deploy ChocoMint

Deploy minting contract on testnet

```
source .env && forge script script/Admin.s.sol:DeployChocoMint --rpc-url $TEST_RPC_URL \
--private-key $TEST_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

Deploy minting contract on mainnet

```
source .env && forge script script/Admin.s.sol:DeployChocoMint --rpc-url $MAIN_RPC_URL  \
--private-key $MAIN_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

NOTE: Purposely do not verify contract for obfuscation.

### 2. Deploy ImplementationUser

Deploy implementation contract on testnet

```
source .env && forge script script/Admin.s.sol:DeployImplementationUser --rpc-url $TEST_RPC_URL \
--private-key $TEST_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

Deploy implementation contract on mainnnet

```
source .env && forge script script/Admin.s.sol:DeployImplementationUser --rpc-url $MAIN_RPC_URL  \
--private-key $MAIN_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

### 3. Deploy ProxyUsers

Deploy proxy user contracts on testnet

```
source .env && forge script script/Admin.s.sol:DeployProxyUsers --rpc-url $TEST_RPC_URL \
--private-key $TEST_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

Deploy proxy user contracts on mainnnet

```
source .env && forge script script/Admin.s.sol:DeployProxyUsers --rpc-url $MAIN_RPC_URL  \
--private-key $MAIN_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

### 4. Mint with Proxies

Make sure settings for a specific mint is made in script/Constants.s.sol

Mint by proxies on testnet

```
source .env && forge script script/Admin.s.sol:Mint --rpc-url $TEST_RPC_URL \
--private-key $TEST_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

Mint by proxies on mainnet

```
source .env && forge script script/Admin.s.sol:Mint --rpc-url $MAIN_RPC_URL  \
--private-key $MAIN_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```
