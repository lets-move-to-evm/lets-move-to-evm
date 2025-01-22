async function main() {
    const [deployer, user1] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const StoreExternal = await ethers.getContractFactory('StoreExternal'); // A Move contract

    const StoreExternalTest = await ethers.getContractFactory(
        'StoreExternalTestV1'
    );

    // Deploy the contract
    const storeExternal = await StoreExternal.deploy();
    console.log('StoreExternal contract address:', storeExternal.address);

    // Deploy the test contract
    const storeExternalTest = await StoreExternalTest.deploy(
        storeExternal.address
    );
    console.log(
        'StoreExternalTest contract address:',
        storeExternalTest.address
    );

    // Get encoding for calling create function
    let encoding = await storeExternalTest.connect(user1).createEncoding();
    console.log('Create encoding: ', encoding);

    // Calling protection layer
    let tx = await storeExternal.protectionLayer(
        storeExternalTest.address,
        encoding
    );
    let result = await tx.wait();
    console.log('Protection layer logs: ', result.logs);

    // Get encoding for calling store function
    encoding = await storeExternalTest.connect(user1).storeEncoding();
    console.log('Store encoding: ', encoding);

    // Calling protection layer
    tx = await storeExternal.protectionLayer(
        storeExternalTest.address,
        encoding
    );
    result = await tx.wait();
    console.log('Protection layer logs: ', result.logs);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
