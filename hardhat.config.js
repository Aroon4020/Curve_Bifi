require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
      // gas: 12000000000000,
      allowUnlimitedContractSize: true,
      accounts: {
      },
      forking: {
        //url: "https://eth-mainnet.g.alchemy.com/v2/MRA8vBbiivNCQvkI_clJi-8XM0-21oMR",
        url: "https://polygon-mainnet.g.alchemy.com/v2/4rVaRCBkGTHxDQcxD_AsDO2LT4lkW5oj",
        //blockNumber: 16981189,
        blockNumber: 41121936,
      },
    },
  },
  solidity: {
    compilers: [{ version: "0.8.17" }, { version: "0.4.24" }, { version: "0.4.17" }, { version: "0.6.0" },{ version: "0.6.2" },{ version: "0.6.6" }],
    settings: {
      metadata: {
        // Not including the metadata hash
        // https://github.com/paulrberg/hardhat-template/issues/31
        bytecodeHash: "none",
      },
      // Disable the optimizer when debugging
      // https://hardhat.org/hardhat-network/#solidity-optimizer-support
      optimizer: {
        enabled: true,
        runs: 800,
      },
    },
  },
};
