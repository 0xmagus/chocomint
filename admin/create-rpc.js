const Web3 = require("web3");

module.exports = (settings, pk) => {
  const public = new Web3(new Web3.providers.HttpProvider(settings.url));
  const flashbots = new Web3(new Web3.providers.HttpProvider(settings.fbUrl));
  const account = pk
    ? public.eth.accounts.privateKeyToAccount(pk)
    : public.eth.accounts.create();
  public.eth.defaultChain = settings.chainId === 1 ? "mainnet" : "goerli";
  flashbots.eth.defaultChain = settings.chainId === 1 ? "mainnet" : "goerli";
  return {
    public,
    flashbots,
    account,
    chainid: settings.chainId,
  };
};
