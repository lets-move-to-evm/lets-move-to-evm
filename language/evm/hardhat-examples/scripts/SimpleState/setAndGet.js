const {
  abi,
} = require("../../artifacts/contracts/SimpleState/SimpleState.json");

async function main() {
  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const [deployer] = await ethers.getSigners();

  console.log("Interacting with SimpleState ", contractAddress);

  const simple = new ethers.Contract(contractAddress, abi, deployer);

  //const tx = await simple.set(BigInt(Math.floor(Math.random() * 100)));
  const tx = await simple.set(BigInt(77), deployer.address);
  // wait for the transaction to be mined
  const receipt = await tx.wait();

  const val = await simple.get(deployer.address);
  console.log("Value of SimpleState after set operation: ", val.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
