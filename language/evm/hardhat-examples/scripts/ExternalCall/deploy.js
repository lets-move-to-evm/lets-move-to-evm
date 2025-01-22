async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account balance:", await ethers.utils.formatEther(weiAmount));

  const ExternalCall = await ethers.getContractFactory("ExternalCall"); // A Move contract
  const externalCall = await ExternalCall.deploy();

  console.log("ExternalCall address:", externalCall.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
