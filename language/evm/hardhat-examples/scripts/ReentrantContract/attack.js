const {
  abi,
} = require("../../artifacts/contracts/ReentrantCall/ReentrantCall.json");

async function main() {
  const contractAddress = "0x11b79123B196202B95c2E2A1055776560a5D457E";
  if (contractAddress === "") {
    console.log("Please provide the contract address");
    return;
  }
  const [deployer] = await ethers.getSigners();

  console.log("Interacting with ExternalCall ", contractAddress);

  const reentrantContract = new ethers.Contract(contractAddress, abi, deployer);

  const val = await reentrantContract.get();
  console.log("Val before attack: ", val.toString());
  
  const tx = await reentrantContract.start_attack(
    "0x36101110151c9c48F448Af643884F90d3775EadD"
  );
  // wait for the transaction to be mined
  const receipt = await tx.wait();
  //console.log("Transaction receipt of set operation", receipt);

  const val2 = await reentrantContract.get();
  console.log("Val after attack: ", val2.toString());
  
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
