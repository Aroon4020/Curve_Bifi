// const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
// const { Contract } = require("ethers");
// const { parseEther } = require("ethers/lib/utils");
// const { ethers } = require("hardhat");
// const hre = require("hardhat");

// describe("Curve Vault", function () {
//   async function deployCurveVaultFixture() {
//     const Vault = await ethers.getContractFactory("CurveVault");
//     const vault = await Vault.deploy(
//       [
//         "0xdAC17F958D2ee523a2206206994597C13D831ec7",
//         "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599",
//       ],
//       "0x3993d34e7e99Abf6B6f367309975d1360222D446",
//       "0xe50e2fe90745A8510491F89113959a1EF01AD400",
//       "0xc4AD29ba4B3c580e6D59105FFf484999997675Ff",
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//       "CURVE-EMBER",
//       "CRV-EMB"
//     );
//     return { vault };
//   }

//   it.only("Should deposit ETH & withDraw in ETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     console.log(vault.address);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [0, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       2,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH & withDraw in WBTC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [0, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       1,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH & withDraw in USDT", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [0, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       0,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit USDT & withDraw in ETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit([10000000, 0, 0], signer.address, 1, {
//       value: parseEther("0"),
//     });
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       2,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit USDT & withDraw in WBTC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit([10000000, 0, 0], signer.address, 1, {
//       value: parseEther("0"),
//     });
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       1,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit USDT & withDraw in USDT", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit([10000000, 0, 0], signer.address, 1, {
//       value: parseEther("0"),
//     });
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       0,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH_USDT & withDraw in USDT", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [10000000, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       0,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH_USDT & withDraw in ETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [10000000, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       2,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH_USDT & withDraw in WBTC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [10000000, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       1,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH_USDT & withDraw in ETH_USDT", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = vault.connect(signer);

//     const tx = await txSigner.deposit(
//       [10000000, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdraw(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       [1, 0, 1],
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit ETH_USDT & withDraw in ETH_USDT_WBTC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const txSigner = await vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [10000000, 0, parseEther("1")],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdraw(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       [1, 1, 1],
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit WBTC & withDraw in WBTC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("WBTC");
//     const contract = await MyContract.attach(
//       "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     const txSigner = await vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [0, 0, parseEther("15")],
//       signer.address,
//       1,
//       {
//         value: parseEther("15"),
//       }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       1,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, parseEther("1"));
//     await txSigner.deposit([0, 93603778, 0], signer.address, 1, {
//       value: parseEther("0"),
//     });
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       1,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });

//   it.only("Should deposit USDT_WBTC_ETH & withDraw in ETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("WBTC");
//     const contract = await MyContract.attach(
//       "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599"
//     );

//     const MyContract1 = await ethers.getContractFactory("TetherToken");
//     const contract1 = await MyContract1.attach(
//       "0xdAC17F958D2ee523a2206206994597C13D831ec7"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     const txSigner = await vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [0, 0, parseEther("15")],
//       signer.address,
//       1,
//       {
//         value: parseEther("15"),
//       }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       1,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//     await contract.connect(signer).approve(vault.address, parseEther("1"));
//     await contract1.connect(signer).approve(vault.address, parseEther("1"));
//     await txSigner.deposit(
//       [10000000, 93603778, parseEther("1")],
//       signer.address,
//       1,
//       {
//         value: parseEther("1"),
//       }
//     );
//     await txSigner.withDrawInOne(
//       vault.balanceOf("0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"),
//       1,
//       2,
//       "0xda9dfa130df4de4673b89022ee50ff26f6ea73cf"
//     );
//   });
// });
