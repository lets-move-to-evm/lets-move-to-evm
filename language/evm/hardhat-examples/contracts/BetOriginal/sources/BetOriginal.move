#[evm_contract]
module Evm::bet_original {
    use Evm::Evm::{sign, self, block_timestamp, sender /* address_of, require address_of,*/};
    use Evm::U256::{U256, add, gt /*gt, sub, zero, le*/};

    #[abi_struct(sig=b"Coin(uint256)")]
    struct Coin has key, store {
        value: U256
    }

    #[external(sig=b"withdrawFrom(address,uint256) returns (Coin)")]
    public native fun withdraw_from (contract: address, acc: address, amount: U256): Coin;

    #[external(sig=b"deposit(address,Coin)")]
    public native fun deposit(contract: address, to: address, coin: Coin);

    struct OracleBet has key {
        coin_address: address,
        player1: address,
        player2: address,
        oracle: address,
        stake: U256,
        deadline: U256,
    }

    struct Bet has key {
        coin: Coin,
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

    #[callable(sig=b"join(uint256)")]
    public fun join(bet: U256) acquires OracleBet {
        let partecipant = sender();
        let oracleBet = borrow_global_mut<OracleBet>(self());
        assert!(oracleBet.player1 == partecipant || oracleBet.player2 == partecipant, 0);
        assert!(bet == oracleBet.stake, 0);
        let coin = withdraw_from(oracleBet.coin_address, partecipant, bet);
        move_to(&sign(partecipant), Bet { coin });
    }

    #[callable(sig=b"win(address)")]
    public fun win(winner: address) acquires OracleBet, Bet {
        let oracle = sender();
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

        let Bet { coin: coin1 } = move_from<Bet>(player1);
        let Bet { coin: coin2 } = move_from<Bet>(player2);
        let Coin { value: value1 } = coin1;
        let Coin { value: value2 } = coin2;
        deposit(coin_address, winner, Coin { value: add(value1, value2) });
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

        let Bet { coin: coin1 } = move_from<Bet>(player1);
        let Bet { coin: coin2 } = move_from<Bet>(player2);

        deposit(coin_address, player1, coin1);
        deposit(coin_address, player2, coin2);
    }
}