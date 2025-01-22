async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account balance:", await ethers.utils.formatEther(weiAmount));

  const FortyTwo = await ethers.getContractFactory("FortyTwo"); // A Move contract
  const fortyTwo = await FortyTwo.deploy();

  console.log("FortyTwo address:", fortyTwo.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
