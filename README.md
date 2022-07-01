# chocomint

Mass minter for nfts. Creates temporary contracts that acts as a proxy users to mint, transfer and self-destruct.

### Quickstart

`forge init`

### Testing in Mainnet

Testing on mainnet is done at a previous block to simulate valid order.

`forge test --fork-url https://eth-mainnet.alchemyapi.io/v2/< your api key > --fork-block-number 14879473 -vvvv --gas-report`
