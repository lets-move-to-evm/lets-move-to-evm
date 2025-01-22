async function main() {
    const [deployer, user1] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const ResourceDropping = await ethers.getContractFactory(
        'ResourceDropping'
    ); // A Move contract

    const ResourceDroppingTestV2 = await ethers.getContractFactory(
        'ResourceDroppingTestV2'
    );

    // Deploy the contract
    const resourceDroppingV2 = await ResourceDropping.deploy();
    console.log(
        'ResourceDropping contract address:',
        resourceDroppingV2.address
    );

    // Deploy the test contract
    const resourceDroppingTest = await ResourceDroppingTestV2.deploy(
        resourceDroppingV2.address
    );
    console.log(
        'ResourceDroppingTestV2 contract address:',
        resourceDroppingTest.address
    );

    // Get encoding for calling external store
    let tx = await resourceDroppingTest
        .connect(user1)
        .protectExternalStoreEncoding();
    console.log('Getting encoding: ', tx);

    // Calling protection layer
    tx = await resourceDroppingV2.protectionLayer(
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
