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

    // Call protection layer test
    const tx = await resourceDroppingTest.wrapResource();
    const receipt = await tx.wait();
    console.log('ResourceDroppingTest.wrapResource() result: ', receipt);

    // Get wrapper resource
    const wrapper = await resourceDroppingTest.getWrapper();
    console.log('ResourceDroppingTest.getWrapper() result: ', wrapper);

    // Get wrapper resource
    const resource = await resourceDroppingTest.createResource();
    console.log('ResourceDroppingTest.createResource() result: ', resource);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
