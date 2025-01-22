# Protection Layer Costs - Test Suite

This directory contains a suite of tests designed to evaluate the gas costs associated with the protection layer mechanism added to the compiler from Move language to EVM. Each test file focuses on a specific function of the protection layer to measure its execution costs.

## Directory Structure

```
/test/ProtectionLayerCosts/
├── README.md
├── testFunction1.test.js
├── testFunction2.test.js
├── testFunction3.test.js
└── ...
```

## Test Files

### `testFunction1.test.js`

-   **Description**: This test evaluates the gas cost for the `function1` of the protection layer.
-   **Purpose**: To measure the execution cost and ensure it is within acceptable limits.

### `testFunction2.test.js`

-   **Description**: This test evaluates the gas cost for the `function2` of the protection layer.
-   **Purpose**: To measure the execution cost and ensure it is within acceptable limits.

### `testFunction3.test.js`

-   **Description**: This test evaluates the gas cost for the `function3` of the protection layer.
-   **Purpose**: To measure the execution cost and ensure it is within acceptable limits.

## Running the Tests

To run the tests, use the following command:

```bash
npx hardhat test
```

Ensure you have the necessary dependencies installed and configured before running the tests.
