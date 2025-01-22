async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account balance:", await ethers.utils.formatEther(weiAmount));

  const SelfState = await ethers.getContractFactory("SelfState"); // A Move contract
  const selfState = await SelfState.deploy();

  console.log("SelfState address:", selfState.address);

  const val = await selfState.get();
  console.log("Value of SelfState before set operation: ", val.toString());

  const tx = await selfState.set(BigInt(44));
  // wait for the transaction to be mined
  const receipt = await tx.wait();
  //console.log("Transaction receipt of set operation", receipt);

  const val2 = await selfState.get();
  console.log("Value of SelfState after set operation: ", val2.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
