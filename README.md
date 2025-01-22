# Let's Move to EVM: Secure Compilation with IRM

This repository contains the implementation of the IRM-based Move to EVM compiler. 
It is a fork of the [original Move language repository](https://github.com/move-language/move).

## IRM-based version vs Orignal version
This repository includes two branches:
- The `main` branch contains the implementation of the IRM-based Move to EVM compiler.
- The `original-compiler` branch contains the original implementation of the Move to EVM compiler.

Both branches have their own contracts and test scripts that can be run to produce the results.

## Installation

If you haven't already, open your terminal and clone [this repository](https://github.com/lets-move-to-evm/lets-move-to-evm):

```bash
git clone https://github.com/lets-move-to-evm/lets-move-to-evm.git
```

Go to the `move` directory and run the `dev_setup.sh` script:

```bash
cd move
./scripts/dev_setup.sh -yptd
```

Follow the script's prompts in order to install all of Move's dependencies.

The script adds environment variable definitions to your `~/.profile` file.
Include them by running this command:

```bash
source ~/.profile
```

## Building the compiler

To build the Move CLI and enable the Move on EVM compiler, use the following command with Cargo:

```
cargo install --path language/tools/move-cli --locked --features evm-backend
```

This will build the Move CLI with the EVM backend enabled.

You can check that it is working by running the following command:

```bash
move --help
```

You should see something like this along with a list and description of a
number of commands:

```
move-cli 0.1.0
Diem Association <opensource@diem.com>
MoveCLI is the CLI that will be executed by the `move-cli` command The `cmd` argument is added here
rather than in `Move` to make it easier for other crates to extend `move-cli`

USAGE:
    move [OPTIONS] <SUBCOMMAND>

OPTIONS:
        --abi                          Generate ABIs for packages
...
```

## Compiling a Move Module

After building the compiler, you can compile a Move module for the EVM architecture with the following command:

```bash
move build --arch ethereum [--force]
```

The --force option can be used to overwrite existing build outputs.

Ensure you run this command from inside a Move module project folder. Some examples can be in the path `language/evm/hardhat-examples/contracts`.

## Tests

### Requirements

To run the tests, ensure that both Node.js and npm are installed on your system.

### Installing npm dependencies

Before running the tests, navigate to the `hardhat-examples` folder and install the required dependencies by running: 
```bash
npm install
```

Next, navigate to the `hardhat-move` folder and run 
```bash
npm install
npm run build 
``` 

### Running tests

After installing all the dependencies, you can execute the tests using Hardhat by running the following command:
```bash
npx harhdat test [path/to/test]
```

Replace [path/to/test] with the specific test file you want to run, or omit it to execute all tests.
