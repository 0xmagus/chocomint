# chocomint

Mass minter for nfts. Creates temporary contracts that acts as a proxy users to mint, transfer and self-destruct.

### Quickstart

Install foundry following thse instructions:
https://book.getfoundry.sh/getting-started/installation.html

```
forge init
forge build
```

### Testing in Mainnet

Testing on mainnet is done at a previous block to simulate valid order. Make sure MAIN_RPC_URL is to an archive node.
Recommend using alchemy endpoint.

```
source .env && forge test --fork-url $MAIN_RPC_URL --fork-block-number 14879473 -vvvv --gas-report
```

### Deploy

Operate on root project directory. Requires eth in the user account for gas. If testnet get eth with a faucet.

#### ChocoMint Deployment

Deploy minting contract on testnet

```
source .env && forge script script/Admin.s.sol:DeployChocoMint --rpc-url $TEST_RPC_URL \
--private-key $TEST_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

Deploy minting contract on mainnet

```
source .env && forge run script/Admin.s.sol:DeployChocoMint --rpc-url $MAIN_RPC_URL  \
--private-key $MAIN_PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --broadcast -vvvv
```

NOTE: Purposely do not verify contract for obfuscation.

#### ImplementationUser Deployment

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
