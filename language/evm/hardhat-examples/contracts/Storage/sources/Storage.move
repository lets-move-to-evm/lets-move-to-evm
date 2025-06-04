#[evm_contract]
module Evm::storage {
    use Evm::Evm::{sign, self /*address_of, require address_of,*/};
    use std::vector;

    
    struct DataStorage has key {
        byte_sequence: vector<u8>,
        text_string: vector<u8>,
    }

    #[create(sig=b"constructor()")]
    public fun constructor() {
        let data = DataStorage {
            byte_sequence: vector::empty<u8>(),
            text_string: vector::empty<u8>(),
        };
        move_to(&sign(self()), data);
    }
        
    #[callable(sig=b"storeBytes(bytes)")]
    public fun store_bytes(data: vector<u8>) acquires DataStorage {
        let storage = borrow_global_mut<DataStorage>(self());
        storage.byte_sequence = data;
    }

    #[callable(sig=b"storeString(string)")]
    public fun store_string(data: vector<u8>) acquires DataStorage {
        let storage = borrow_global_mut<DataStorage>(self());
        storage.text_string = data;
    }
}