async function main() {
    const [deployer, user1] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const BasicCoin = await ethers.getContractFactory('BasicCoin'); // A Move contract

    const BasicCoinTestV1 = await ethers.getContractFactory('BasicCoinTestV1');

    // Deploy the contract
    const basicCoin = await BasicCoin.deploy();
    console.log('BasicCoin contract address:', basicCoin.address);

    // Deploy the test contract
    const basicCoinTest = await BasicCoinTestV1.deploy(basicCoin.address);
    console.log('BasicCoinTestV1 contract address:', basicCoinTest.address);

    console.log('User 1 address:', user1.address);

    // Get register encoding
    let encoding = await basicCoinTest.connect(user1).registerEncoding();
    console.log('Register encoding: ', encoding);

    // Register : calling protection layer
    let tx = await basicCoin
        .connect(user1)
        .protectionLayer(basicCoinTest.address, encoding);
    let result = await tx.wait();
    console.log('Protection layer result: ', result.logs);

    // Get balance
    tx = await basicCoin.getBalance(user1.address);
    console.log('Balance: ', tx.toString());

    // Get withdraw 0 encoding
    encoding = await basicCoinTest.connect(user1).withdrawEncoding('0');
    console.log('Withdraw encoding: ', encoding);

    // Withdraw : calling protection layer
    tx = await basicCoin
        .connect(user1)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Withdraw result: ', result.logs);

    // Get balance
    tx = await basicCoin.connect(user1).getBalance(user1.address);
    console.log('Balance: ', tx);

    // Get mint to encoding
    encoding = await basicCoinTest
        .connect(deployer)
        .mintToEncoding('10', user1.address);

    // Mint to : calling protection layer
    console.log('Mint to encoding: ', encoding);
    tx = await basicCoin
        .connect(deployer)
        .protectionLayer(basicCoinTest.address, encoding);

    result = await tx.wait();
    console.log('Mint to result: ', result.logs);

    // Get balance
    tx = await basicCoin.connect(user1).getBalance(user1.address);
    console.log('Balance: ', tx);

    // Get deposit encoding
    encoding = await basicCoinTest.connect(user1).depositEncoding();
    console.log('Deposit encoding: ', encoding);

    // Deposit : calling protection layer
    tx = await basicCoin
        .connect(user1)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Deposit result: ', result.logs);

    // Get withdraw 5 encoding
    encoding = await basicCoinTest.connect(user1).withdrawEncoding('5');
    console.log('Withdraw encoding: ', encoding);

    // Withdraw : calling protection layer
    tx = await basicCoin
        .connect(user1)
        .protectionLayer(basicCoinTest.address, encoding);
    result = await tx.wait();
    console.log('Withdraw result: ', result.logs);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
