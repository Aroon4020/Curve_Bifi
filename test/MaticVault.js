// const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
// const { Contract } = require("ethers");
// const { parseEther } = require("ethers/lib/utils");
// const { ethers } = require("hardhat");
// const hre = require("hardhat");

// describe("Curve Vault", function () {
//   async function deployCurveVaultFixture() {
//     const Vault = await ethers.getContractFactory("CurveMatic");
//     const vault = await Vault.deploy(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//       parseEther("2"),
//       "CURVE-EMBER",
//       "CRV-EMB"
//     );
//     return { vault };
//   }

//   it("Should deposit MATIC & withDraw in MATIC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),
//       1,
//       0,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in all", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("100"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("100") }
//     );
//     await txSigner.withdraw(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       [1, 1, 1, 1, 1, 1],
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in DAI", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       0,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in USDC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       1,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in USDT", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       2,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in WBTC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       3,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in WETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       4,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in WETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       4,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC & withDraw in WETH", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       4,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit MATIC&USDC & withDraw in USDC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 10000, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       1,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit in All & withDraw in USDC", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const contract = await MyContract.attach(
//       "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
//     );
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     await contract.connect(signer).approve(vault.address, 10000000);
//     const tx = await txSigner.deposit(
//       [parseEther("1"), 0, 10000, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("1") }
//     );
//     await txSigner.withdrawInOne(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       1,
//       1,
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });

//   it("Should deposit all & withDraw in all", async function () {
//     const { vault } = await loadFixture(deployCurveVaultFixture);
//     await ethers.provider.send("hardhat_impersonateAccount", [
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97",
//     ]);
//     const signer = await ethers.getSigner(
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//     const txSigner = vault.connect(signer);
//     const tx = await txSigner.deposit(
//       [parseEther("100"), 0, 0, 0, 0, 0],
//       signer.address,
//       1,
//       { value: parseEther("100") }
//     );
//     await txSigner.withdraw(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       [1, 1, 1, 1, 1, 1],
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );

//     const MyContract = await ethers.getContractFactory("TetherToken");
//     const DAI = await MyContract.attach(
//       "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"
//     );
//     const USDC = await MyContract.attach(
//       "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
//     );
//     const USDT = await MyContract.attach(
//       "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"
//     );
//     const WBTC = await MyContract.attach(
//       "0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6"
//     );
//     const WETH = await MyContract.attach(
//       "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619"
//     );

//     await DAI.connect(signer).approve(vault.address, 1000);
//     await USDC.connect(signer).approve(vault.address, 10000000);
//     await USDT.connect(signer).approve(vault.address, 10000);
//     await WBTC.connect(signer).approve(vault.address, 10000000);
//     await WETH.connect(signer).approve(vault.address, 10000000);

//     await txSigner.deposit(
//       [parseEther("100"), 1000, 10000000, 10000, 1000, 1000000],
//       signer.address,
//       1,
//       { value: parseEther("100") }
//     );
//     await txSigner.withdraw(
//       vault.balanceOf("0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"),

//       [1, 1, 1, 1, 1, 1],
//       "0xDbfA076EDBFD4b37a86D1d7Ec552e3926021fB97"
//     );
//   });
// });
