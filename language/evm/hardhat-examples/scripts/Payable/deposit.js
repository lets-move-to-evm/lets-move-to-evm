const { abi } = require("../../artifacts/contracts/Payable/Payable.json");

async function main() {
  const contractAddress = "0x9853Cdb0CCd0d85d24462626E598Bb7aC9D63910";
  const [deployer] = await ethers.getSigners();

  console.log("Interacting with Payable ", contractAddress);

  const auction = new ethers.Contract(contractAddress, abi, deployer);

  //const tx = await auction.set(BigInt(Math.floor(Math.random() * 100)));
  const tx = await auction.deposit({ value: ethers.utils.parseEther("0.01") });
  // wait for the transaction to be mined
  const receipt = await tx.wait();
  console.log("Transaction receipt of set operation", receipt);

  const val = await auction.deposited();
  console.log(
    "Value of SimpleState after set operation: ",
    ethers.utils.formatEther(val)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
