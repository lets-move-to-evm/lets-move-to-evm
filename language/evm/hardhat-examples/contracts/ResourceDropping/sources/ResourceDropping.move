#[evm_contract]
module Evm::ResourceDropping {
    use Evm::Evm::{sender, sign, call, callback, self, emit, require};
    use Evm::U256::{Self, U256, zero, u256_from_u128};

    #[storage]
    struct ProtectionLayer has key {
        flag: bool,
        id: U256,
        sizeofH: U256,
        protected_contract: address,
        _signer: address,
    }

    #[abi_struct(sig=b"DroppedRes(uint256,uint256)")]
    struct DroppedRes has key {
        val: U256,
        val2: U256
    }

    #[event(sig=b"CallbackData(bytes)")]
    struct CallbackData {
        cbdata: vector<u8>,
    }
 
    #[create(sig=b"constructor()")]
    public fun init_module(): ProtectionLayer{
        let res = DroppedRes {
            val :zero(),
            val2: zero()
        };
        move_to<DroppedRes>(&sign(sender()), res);
        ProtectionLayer {
            flag: false,
            id: zero(),
            sizeofH: zero(),
            _signer: @0x0,
            protected_contract: @0x0
        }
    }

    #[callable(sig=b"allocate(uint256,uint256)")]
    public fun allocate(val: U256, val2: U256) {
        let res = DroppedRes {
            val,
            val2
        };
        write_to_storage(res);
    }

    #[callable(sig=b"writeToStorage(uint256)")]
    public fun write_to_storage(res: DroppedRes) {
        move_to<DroppedRes>(&sign(sender()), res);
    }

    #[callable(sig=b"remove() returns (uint256)")]
    public fun remove() : DroppedRes acquires DroppedRes {
        move_from<DroppedRes>(sender())
    }

    #[callable(sig=b"sink(uint256)")]
    public fun sink(res: DroppedRes) {
        let DroppedRes{ val: _, val2: _ } = res;
    }

    #[callable(sig=b"dropRes() returns (uint256)"), view]
    public fun drop_res() : DroppedRes {
        let res = DroppedRes {
            val: u256_from_u128(44),
            val2: u256_from_u128(14)
        };
        res
    }
 
    #[callable(sig=b"retUint() returns (uint256)"), view]
    public fun ret_uint() : U256 {
        u256_from_u128(44)
    }

    #[callable(sig=b"getUint(uint256)")]
    public fun get_uint(num: U256) {
        write_to_storage(DroppedRes{
            val: num,
            val2: num
        });
    }

    // #[callable(sig=b"set(uint256,address)")]
    // public fun set(val: U256, addr: address) acquires DroppedRes {
    //     let s = borrow_global_mut<DroppedRes>(addr);
    //     s.val = val;
    // }
    
    // #[callable(sig=b"edit(&DroppedRres,uint256)")]
    // // this won't be translated to EVM
    // public fun edit(res_ref: &mut DroppedRes, val: U256) {
    //     res_ref.val = val;
    // }
    
    // #[callable(sig=b"read(address) returns (uint256)"), view]
    // public fun read(addr: address): U256 acquires DroppedRes {
    //     let s = borrow_global<DroppedRes>(addr);
    //     s.val
    // }

    // #[callable(sig=b"doubleDrop() returns (DroppedRes,DroppedRes)"), view]
    // public fun double_drop() : (DroppedRes, DroppedRes) {
    //     let res1 = DroppedRes {
    //         val: u256_from_u128(44),
    //         val2: u256_from_u128(14)
    //     };
    //     let res2 = DroppedRes {
    //         val: u256_from_u128(44),
    //         val2: u256_from_u128(14)
    //     };
    //     (res1, res2)
    // }
    
    // #[callable(sig=b"dropResFromStorage(address) returns (DroppedRes)")]
    // public fun drop_res_from_storage(addr: address) : DroppedRes acquires DroppedRes {
    //     let res = move_from<DroppedRes>(addr);
    //     res
    // }

    // #[callable(sig=b"protect(address,address,bytes) returns (bool)")]
    // public fun protect(protected_contract: address, _signer: address, cb: vector<u8>) : bool acquires ProtectionLayer {
    //     // assert!(protected_contract == _signer, 0);
    //     require(protected_contract == _signer, b"protected_contract must be equal to signer");
    //     let state = borrow_global_mut<ProtectionLayer>(self());
    //     state.flag = true;
    //     state.protected_contract = protected_contract;
    //     state._signer = _signer;
    //     // emit(CallbackData{cbdata: cb});
    //     //true
    //     call(protected_contract, zero(), cb)
    // }

    // #[callable(sig=b"protect(address,address,bytes) returns (bool)")]
    // public fun protect(protected_contract: address, _signer: address, cb: vector<u8>) : bool{
    //     callback(cb)
    // }
}