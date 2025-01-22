async function main() {
    const [deployer] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const SimpleState = await ethers.getContractFactory('SimpleState3'); // A Move contract
    const simpleState = await SimpleState.deploy();

    console.log('SimpleState address:', simpleState.address);

    const val = await simpleState.get();
    console.log('Value of SimpleState before set operation: ', val.toString());

    const tx = await simpleState.edit(BigInt(55));

    const receipt = await tx.wait();

    const val2 = await simpleState.get();
    console.log('Value of SimpleState after set operation: ', val2.toString());

    const tx2 = await simpleState.remove();
    const receipt2 = await tx2.wait();

    const tx3 = await simpleState.initialize();
    const receipt3 = await tx3.wait();

    const val3 = await simpleState.get();
    console.log(
        'Value of SimpleState after remove and initialize operation: ',
        val3.toString()
    );
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
