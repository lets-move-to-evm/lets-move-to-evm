async function main() {
    const [deployer, user1] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const ResourceDropping = await ethers.getContractFactory(
        'ResourceDropping'
    ); // A Move contract

    const ResourceDroppingTest = await ethers.getContractFactory(
        'ResourceDroppingTest'
    );

    // Deploy the contract
    const resourceDropping = await ResourceDropping.deploy();
    console.log('ResourceDropping contract address:', resourceDropping.address);

    // Deploy the test contract
    const resourceDroppingTest = await ResourceDroppingTest.deploy(
        resourceDropping.address
    );
    console.log(
        'ResourceDroppingTest contract address:',
        resourceDroppingTest.address
    );

    // Get encoding for calling external store
    let tx = await resourceDroppingTest
        .connect(user1)
        .protectExternalStoreEncoding();
    console.log('Getting encoding: ', tx);

    // Calling protection layer
    tx = await resourceDropping.protectionLayer(
        resourceDroppingTest.address,
        tx
    );
    let result = await tx.wait();
    console.log('Protection layer result: ', result);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
