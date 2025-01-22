async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account balance:", await ethers.utils.formatEther(weiAmount));

  const ReentrantCall = await ethers.getContractFactory("ReentrantCall"); // A Move contract
  const reentrantCall = await ReentrantCall.deploy();

  const AttackerContract = await ethers.getContractFactory("AttackerV1"); // Solidity contract
  const attackerContract = await AttackerContract.deploy();

  console.log("Reentrant contract address:", reentrantCall.address);
  console.log("Attacker conotract address:", attackerContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
