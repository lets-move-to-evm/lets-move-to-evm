#[evm_contract]
module Evm::imperfect_locker {

    use Evm::Evm::{protection_layer_signer_address, sign};    
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_POOL_DOES_NOT_EXIST: u64 = 2;

    // Represents a liquidity pool for impermanent loss calculation
    struct Pool has key {
        // Initial amount of each coin when the pool was created
        initial_amount_a: u64,
        initial_amount_b: u64,
        // Current amount of each coin in the pool
        current_amount_a: u64,
        current_amount_b: u64,
        // Price of each coin when the pool was created
        initial_price_a: u64,
        initial_price_b: u64,
        // Current price of each coin for comparison
        current_price_a: u64,
        current_price_b: u64,
    }

    #[callable(sig=b"initializePool(uint64,uint64,uint64,uint64)")]
    // new liquidity pool for impermanent loss tracking
    public entry fun initialize_pool(
        initial_amount_a: u64,
        initial_amount_b: u64,
        initial_price_a: u64,
        initial_price_b: u64
    ) {
        let addr = protection_layer_signer_address();

        let pool = Pool {
            initial_amount_a,
            initial_amount_b,
            current_amount_a: initial_amount_a,
            current_amount_b: initial_amount_b,
            initial_price_a,
            initial_price_b,
            current_price_a: initial_price_a,
            current_price_b: initial_price_b,
        };
        move_to(&sign(addr), pool);
    }

    #[callable(sig=b"updatePool(uint64,uint64,uint64,uint64)")]
    // Update the pool with current prices and amounts
    public entry fun update_pool(
        current_amount_a: u64,
        current_amount_b: u64,
        current_price_a: u64,
        current_price_b: u64
    ) acquires Pool {
        let addr = protection_layer_signer_address();
        assert!(exists<Pool>(addr), E_POOL_DOES_NOT_EXIST);

        let pool = borrow_global_mut<Pool>(addr);
        pool.current_amount_a = current_amount_a;
        pool.current_amount_b = current_amount_b;
        pool.current_price_a = current_price_a;
        pool.current_price_b = current_price_b;
    }

    #[callable(sig=b"calculateImpermanentLoss(address) returns (uint64)")]
    // Calculate the impermanent loss for the pool
    public fun calculate_impermanent_loss(pool_addr: address): u64 acquires Pool {
        assert!(exists<Pool>(pool_addr), E_POOL_DOES_NOT_EXIST);

        let pool = borrow_global<Pool>(pool_addr);

        // Calculate value if tokens were held rather than pooled
        let hold_value_a = pool.initial_amount_a * pool.current_price_a / pool.initial_price_a;
        let hold_value_b = pool.initial_amount_b * pool.current_price_b / pool.initial_price_b;

        // Calculate current pool value
        let pool_value_a = pool.current_amount_a * pool.current_price_a;
        let pool_value_b = pool.current_amount_b * pool.current_price_b;

        // Impermanent Loss calculation (simplified)
        let loss = if (hold_value_a + hold_value_b > pool_value_a + pool_value_b) {
            (hold_value_a + hold_value_b) - (pool_value_a + pool_value_b)
        } else {
            0
        };

        loss
    }
}
