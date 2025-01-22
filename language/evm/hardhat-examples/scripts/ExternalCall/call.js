const {
  abi,
} = require("../../artifacts/contracts/ExternalCall/ExternalCall.json");

async function main() {
  const contractAddress = "0xafC65a3Dd4e7C0f7b4199FD1a501A054929142fd";
  const [deployer] = await ethers.getSigners();

  console.log("Interacting with ExternalCall ", contractAddress);

  const externalCall = new ethers.Contract(contractAddress, abi, deployer);

  const tx = await externalCall.call_forty_two(
    "0xC469642A5E5627B965FC3Ce944290EB896D61190"
  );
  // wait for the transaction to be mined
  console.log("Forty two function called", tx);
  //const receipt = await tx.wait();
  //console.log("Transaction receipt of set operation", receipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
