async function main() {
    const [deployer, user1] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const ResourceDropping = await ethers.getContractFactory(
        'ResourceDropping'
    ); // A Move contract

    // Deploy the contract
    const resourceDropping = await ResourceDropping.deploy(
        BigInt(14),
        deployer.address
    );

    console.log('ResourceDropping contract address:', resourceDropping.address);

    // Call drop resource
    const dropped = await resourceDropping.dropRes();
    console.log('Dropped: ', dropped.toString());

    const val = await resourceDropping.read(deployer.address);
    console.log(
        'Value of ResourceDropping before set operation: ',
        val.toString()
    );

    const tx = await resourceDropping.set(BigInt(44), deployer.address);
    const receipt = await tx.wait();

    const val2 = await resourceDropping.read(deployer.address);
    console.log('Value of SimpleState after set operation: ', val2.toString());

    const tx2 = await resourceDropping.connect(user1).allocate(BigInt(44));
    const receipt2 = await tx2.wait();

    const val3 = await resourceDropping.read(user1.address);
    console.log(
        'Value of SimpleState after allocate operation: ',
        val3.toString()
    );
    /*
    const val = await simpleState.read(deployer.address);
    console.log("Value of SimpleState before set operation: ", val.toString());
  
    const tx = await simpleState.set(BigInt(44), deployer.address);
  
    const receipt = await tx.wait();
  
    const val2 = await simpleState.read(deployer.address);
    console.log("Value of SimpleState after set operation: ", val2.toString());
    */
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
