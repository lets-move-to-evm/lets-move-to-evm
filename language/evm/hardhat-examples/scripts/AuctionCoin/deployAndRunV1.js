async function main() {
    const [deployer, user1, user2] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const BasicCoin = await ethers.getContractFactory('BasicCoin'); // A Move contract
    const BasicCoinTestV1 = await ethers.getContractFactory('BasicCoinTestV1');

    const Auction = await ethers.getContractFactory('Auction');

    // Deploy Coin contract
    const basicCoin = await BasicCoin.deploy();
    console.log('BasicCoin contract address:', basicCoin.address);

    // Deploy CoinTest contract
    const basicCoinTest = await BasicCoinTestV1.deploy(basicCoin.address);
    console.log('BasicCoinTestV1 contract address:', basicCoinTest.address);

    // Register deployer and users

    // Get register encoding for deployer
    let encoding = await basicCoinTest.connect(deployer).registerEncoding();
    console.log('Register encoding: ', encoding);
    // Calling protection layer
    let tx = await basicCoin
        .connect(deployer)
        .protectionLayer(basicCoinTest.address, encoding);
    let result = await tx.wait();
    console.log('Protection layer result: ', result.logs);

    // Get register encoding for user1
    encoding = await basicCoinTest.connect(user1).registerEncoding();
    console.log('Register encoding: ', encoding);
    // Calling protection layer
    tx = await basicCoin
        .connect(user1)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Protection layer result: ', result.logs);

    // Get register encoding for user2
    encoding = await basicCoinTest.connect(user2).registerEncoding();
    console.log('Register encoding: ', encoding);
    // Calling protection layer
    tx = await basicCoin
        .connect(user2)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Protection layer result: ', result.logs);

    // Mint coins to deployer
    encoding = await basicCoinTest
        .connect(deployer)
        .mintToEncoding('10', deployer.address);
    console.log('Mint to encoding: ', encoding);
    tx = await basicCoin
        .connect(deployer)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Mint to result: ', result.logs);

    // Mint coins to user1
    encoding = await basicCoinTest
        .connect(deployer)
        .mintToEncoding('10', user1.address);
    console.log('Mint to encoding: ', encoding);
    tx = await basicCoin
        .connect(deployer)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Mint to result: ', result.logs);

    // Mint coins to user2
    encoding = await basicCoinTest
        .connect(deployer)
        .mintToEncoding('10', user2.address);
    console.log('Mint to encoding: ', encoding);
    tx = await basicCoin
        .connect(deployer)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Mint to result: ', result.logs);

    // Deploy auction contract
    const auction = await Auction.deploy(basicCoin.address);
    console.log('Auction contract address:', auction.address);

    console.log('User 1 address:', user1.address);

    // Start auction
    encoding = await auction.connect(deployer).startAuctionEncoding();
    console.log('Start auction encoding: ', encoding);
    tx = await basicCoin
        .connect(deployer)
        .protectionLayer(auction.address, encoding);
    result = await tx.wait();
    console.log('Start auction result: ', result.logs);

    // Get bid encoding
    let amount = '1';
    encoding = await auction.connect(user1).bidEncoding(amount);
    console.log('Bid encoding: ', encoding);

    // Calling protection layer
    tx = await basicCoin
        .connect(user1)
        .protectionLayer(auction.address, encoding);
    result = await tx.wait();
    console.log('Protection layer result: ', result.logs);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
