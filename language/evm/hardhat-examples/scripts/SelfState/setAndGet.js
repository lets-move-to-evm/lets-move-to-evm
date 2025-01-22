const {
  abi,
} = require("../../artifacts/contracts/SimpleState/SimpleState.json");

async function main() {
  const contractAddress = "0x4347ABC98e33D2a09c9FCb968f24E2aCa4353063";
  const [deployer] = await ethers.getSigners();

  console.log("Interacting with SimpleState ", contractAddress);

  const simple = new ethers.Contract(contractAddress, abi, deployer);

  //const tx = await simple.set(BigInt(Math.floor(Math.random() * 100)));
  const tx = await simple.set(BigInt(44), deployer.address);
  // wait for the transaction to be mined
  const receipt = await tx.wait();
  console.log("Transaction receipt of set operation", receipt);

  const val = await simple.get(deployer.address);
  console.log("Value of SimpleState after set operation: ", val.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
