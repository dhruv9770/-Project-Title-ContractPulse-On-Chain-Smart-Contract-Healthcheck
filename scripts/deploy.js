const hre = require("hardhat");

async function main() {
  const ContractPulse = await hre.ethers.getContractFactory("ContractPulse");
  const contractPulse = await ContractPulse.deploy();

  await contractPulse.deployed();
  console.log("ContractPulse deployed to:", contractPulse.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
