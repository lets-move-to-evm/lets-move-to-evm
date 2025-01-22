async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account balance:", await ethers.utils.formatEther(weiAmount));

  const SimpleState = await ethers.getContractFactory("SimpleState"); // A Move contract
  const simpleState = await SimpleState.deploy(BigInt(14), deployer.address);

  console.log("SimpleState address:", simpleState.address);

  const val = await simpleState.get(deployer.address);
  console.log("Value of SimpleState before set operation: ", val.toString());

  const tx = await simpleState.set(BigInt(44), deployer.address);

  const receipt = await tx.wait();

  const val2 = await simpleState.get(deployer.address);
  console.log("Value of SimpleState after set operation: ", val2.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
