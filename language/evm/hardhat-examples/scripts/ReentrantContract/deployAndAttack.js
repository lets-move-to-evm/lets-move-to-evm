async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account balance:", await ethers.utils.formatEther(weiAmount));

  const ReentrantCall = await ethers.getContractFactory("ReentrantContract"); // A Move contract
  const vulnerableContract = await ReentrantCall.deploy();

  const AttackerContract = await ethers.getContractFactory("AttackerV1"); // Solidity contract
  const attackerContract = await AttackerContract.deploy();

  console.log("Vulnerable contract address:", vulnerableContract.address);
  console.log("Attacker contract address:", attackerContract.address);

  const val = await vulnerableContract.get();
  console.log("Val before attack: ", val.toString());
  
  const tx = await vulnerableContract.start_attack(attackerContract.address);
  
  // wait for the transaction to be mined
  const receipt = await tx.wait();
  //console.log("Transaction receipt of set operation", receipt);

  const val2 = await vulnerableContract.get();
  console.log("Val after attack: ", val2.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
