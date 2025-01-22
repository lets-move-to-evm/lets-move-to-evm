const { abi } = require("../../artifacts/contracts/Auction/Auction.json");

async function main() {
  const auctionAddress = "0x33BD632F26F517F7908204f7BFaA34e1B7953795";
  const [deployer] = await ethers.getSigners();

  console.log("Bidding to Auction ", auctionAddress);

  //const weiAmount = (await deployer.getBalance()).toString();
  //console.log("Account balance:", await ethers.utils.formatEther(weiAmount));
  const auction = new ethers.Contract(auctionAddress, abi, deployer);

  const tx = await auction.bid({ value: ethers.utils.parseEther("0.01") });

  // wait for the transaction to be mined
  const receipt = await tx.wait();

  console.log("Transaction receipt", receipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
