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

  const MyCoin = await ethers.getContractFactory("MyCoin"); // A Move contract
  const mycoin = await MyCoin.deploy();

  console.log("MyCoin address:", mycoin.address);

  const val = await mycoin.balanceOf(deployer.address);
  console.log("Value of MyCoin before transfer operation: ", val.toString());

  const tx1 = await mycoin.connect(user1).optIn();
  const receipt1 = await tx1.wait();
  const val1 = await mycoin.balanceOf(deployer.address);

  const tx = await mycoin.transfer(user1.address, BigInt(101));

  const receipt = await tx.wait();

  const val2 = await mycoin.balanceOf(deployer.address);
  const val3 = await mycoin.balanceOf(user1.address);
  console.log("Value of MyCoin after transfer operation: ", val2.toString());
  console.log("Value of MyCoin after transfer operation: ", val3.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
