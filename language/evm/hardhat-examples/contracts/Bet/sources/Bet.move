#[evm_contract]
module Evm::bet {
    use Evm::Evm::{sign, self, block_timestamp, emit/*sender, address_of, require address_of,*/};
    use Evm::U256::{U256, gt /*gt, add, sub, zero, le*/};

    #[external(sig=b"withdraw(uint256) returns (uint256)")]
    public native fun withdraw (contract: address, amount: U256): U256;

    #[external(sig=b"unstoreExternal(uint256)")]
    public native fun unstore_external(contract: address, coin: U256);

    #[external(sig=b"deposit(address,uint256)")]
    public native fun deposit(contract: address, to: address, coin: U256);

    #[external(sig=b"storeExternal(uint256)")]
    public native fun store_external(contract: address, coin: U256);

    #[external(sig=b"coinValue(uint256) returns (uint256)")]
    public native fun coin_value(contract: address, coin: U256): U256;

    #[external(sig=b"merge(uint256,uint256)")]
    public native fun merge(contract: address, coin1: U256, coin2: U256);

    struct OracleBet has key {
        coin_address: address,
        player1: address,
        player2: address,
        oracle: address,
        stake: U256,
        deadline: U256,
    }

    struct Bet has key {
        coinId: U256,
    }

    #[create(sig=b"constructor(address,address,address,uint256,uint256,address)")]
    public fun create(
        player1: address, 
        player2: address, 
        oracle: address, 
        stake: U256, 
        deadline: U256, 
        coin_address: address
    ) {
        let state = OracleBet{
            coin_address: coin_address,
            player1: player1,
            player2: player2,
            oracle: oracle,
            stake: stake,
            deadline: deadline,
        };
        move_to(&sign(self()), state);
    }

    #[callable(sig=b"join(address,uint256)")]
    public fun join(partecipant: address, bet: U256) acquires OracleBet {
        let oracleBet = borrow_global_mut<OracleBet>(self());
        assert!(oracleBet.player1 == partecipant || oracleBet.player2 == partecipant, 0);
        assert!(bet == oracleBet.stake, 0);
        let coin = withdraw(oracleBet.coin_address, bet);
        store_external(oracleBet.coin_address, coin);
        move_to(&sign(partecipant), Bet { coinId: coin });
    }

    #[callable(sig=b"win(address,address)")]
    public fun win(oracle: address, winner: address) acquires OracleBet, Bet {
        assert!(exists<OracleBet>(self()), 0);
        let OracleBet {
            coin_address,
            player1,
            player2,
            oracle: oracle_address,
            stake: _,
            deadline: _
        } = move_from<OracleBet>(self());
        
        assert!(oracle == oracle_address, 0);
        assert!(winner == player1 || winner == player2, 0);

        let Bet { coinId: coinId1 } = move_from<Bet>(player1);
        let Bet { coinId: coinId2 } = move_from<Bet>(player2);
        unstore_external(coin_address, coinId1);
        unstore_external(coin_address, coinId2);
        merge(coin_address, coinId1, coinId2);
        deposit(coin_address, winner, coinId1);
    }

    #[callable(sig=b"timeout()")]
    public fun timeout() acquires OracleBet, Bet {
        assert!(exists<OracleBet>(self()), 0);
        let OracleBet {
            coin_address,
            player1,
            player2,
            oracle: _,
            stake: _,
            deadline: deadline
        } = move_from<OracleBet>(self());

        assert!(gt(block_timestamp(), deadline), 0);

        let Bet { coinId: coinId1 } = move_from<Bet>(player1);
        let Bet { coinId: coinId2 } = move_from<Bet>(player2);
        unstore_external(coin_address, coinId1);
        unstore_external(coin_address, coinId2);
        deposit(coin_address, player1, coinId1);
        deposit(coin_address, player2, coinId2);
    }
}