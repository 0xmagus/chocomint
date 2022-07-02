/** Admin cli tool to perform commands. */

const networkSettings = require("./network-settings");
const createRpc = require("./create-rpc");

require("dotenv").config();

const getGasEstimateGwei = async (fast = false) => {
  const response = await fetch(
    "https://api.etherscan.io/api?module=gastracker&action=gasoracle"
  );
  const data = await response.json();
  const base = data.result.suggestBaseFee;
  const priority =
    (fast ? data.result.FastGasPrice : data.result.ProposeGasPrice) - base;
  return {
    base,
    priority,
  };
};

const main = async () => {
  const env = process.env.NODE_ENV || "test";
  let pk, contract, web3;
  if (env === "main") {
    pk = process.env.MAIN_PRIVATE_KEY;
    contract = process.env.MAIN_CONTRACT;
    web3 = createRpc(networkSettings.main, pk);
  } else if (env === "test") {
    pk = process.env.TEST_PRIVATE_KEY;
    contract = process.env.TEST_CONTRACT;
    web3 = createRpc(networkSettings.test, pk);
  } else {
    throw Error("Invalid environment. Must be main or test.");
  }
  // For testing purposes.
  console.log(env, pk, contract, web3.account);
};

main();
