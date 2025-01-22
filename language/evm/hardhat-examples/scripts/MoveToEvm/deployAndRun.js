async function main() {
  const [deployer, user1] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("User1 account at address :", user1.address);

  const deployerWeiAmount = (await deployer.getBalance()).toString();
  const user1WeiAmount = (await user1.getBalance()).toString();

  console.log(
    "Deployer account balance:",
    await ethers.utils.formatEther(deployerWeiAmount)
  );
  console.log(
    "User1 account balance:",
    await ethers.utils.formatEther(user1WeiAmount)
  );

  const LinearCall = await ethers.getContractFactory("LinearCall"); // LinearCall Move contract
  const linearCall = await LinearCall.deploy();
  console.log("LinearCall address:", linearCall.address);

  const MoveToEvm = await ethers.getContractFactory("MoveToEvm");
  const moveToEvm = await MoveToEvm.deploy();
  console.log("MoveToEvm address:", moveToEvm.address);

  const val = await linearCall.entry(moveToEvm.address);
  console.log(
    "Value of LinearCall before transfer operation: ",
    val.toString()
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
