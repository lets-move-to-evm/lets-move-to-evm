async function main() {
    const [deployer, user1] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    const weiAmount = (await deployer.getBalance()).toString();

    console.log('Account balance:', await ethers.utils.formatEther(weiAmount));

    const CallbackCaller = await ethers.getContractFactory('CallbackCaller'); // A Move contract

    // Deploy the contract
    const callbackCaller = await CallbackCaller.deploy();

    console.log('CallbackCaller contract address:', callbackCaller.address);

    const tx = await callbackCaller.wrapResource1();
    const result = await tx.wait();
    console.log('CallbackCaller.wrapResource1() result: ', result);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
