#[evm_contract]
module Evm::nav {

    use Evm::Evm::{protection_layer_signer_address, sign};

    // Struct to hold the total asset value and total token supply
    struct NAVData has key {
        total_asset_value: u64,    // Total value of assets
        total_token_supply: u64,   // Total supply of the token
    }

    // Initialize the NAV data for an account
    #[callable(sig=b"initNav()")]
    public fun init_nav() {
        let account_addr = protection_layer_signer_address();
        let nav_data = NAVData {
            total_asset_value: 0,
            total_token_supply: 0,
        };
        move_to(&sign(account_addr), nav_data);
    }

    // Function to update the total asset value
    #[callable(sig=b"updateAssetValue(uint64)")]
    public fun update_asset_value(new_asset_value: u64) acquires NAVData {
        let nav_data = borrow_global_mut<NAVData>(protection_layer_signer_address());
        nav_data.total_asset_value = new_asset_value;
    }

    // Function to update the total token supply
    #[callable(sig=b"updateTokenSupply(uint64)")]
    public fun update_token_supply(new_token_supply: u64) acquires NAVData {
        let nav_data = borrow_global_mut<NAVData>(protection_layer_signer_address());
        nav_data.total_token_supply = new_token_supply;
    }

    // Function to calculate the NAV
    #[callable(sig=b"calculateNav() returns (uint64)")]
    public fun calculate_nav(): u64 acquires NAVData {
        let nav_data = borrow_global<NAVData>(protection_layer_signer_address());
        if (nav_data.total_token_supply > 0) {
            nav_data.total_asset_value / nav_data.total_token_supply
        } else {
            0 // Return 0 if token supply is zero to avoid division by zero
        }
    }
}
