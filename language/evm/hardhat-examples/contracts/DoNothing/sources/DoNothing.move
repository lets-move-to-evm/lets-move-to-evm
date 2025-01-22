#[evm_contract]
module Evm::do_nothing {

    #[callable(sig=b"doNothing()", view)]
    public fun do_nothing() {}
}