#[evm_contract]
module Evm::MultiAdmin {
    use Evm::Evm::{protection_layer_signer_address, sign};

    struct AdminData has key, store {
        admin: address,
    }

    #[callable(sig=b"initialize()")]
    fun init_module() {
        let sender_addr = protection_layer_signer_address();
        move_to(&sign(sender_addr), AdminData {
            admin: sender_addr,
        });
    }

    #[callable(sig=b"setAdmin(address)")]
    public entry fun set_admin(new_admin: address) acquires AdminData {
        let sender = protection_layer_signer_address();
        let admin_data = borrow_global_mut<AdminData>(sender);
        assert!(admin_data.admin == sender, 0);
        admin_data.admin = new_admin;
    }

}