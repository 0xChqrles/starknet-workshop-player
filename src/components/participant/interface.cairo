use starknet::ContractAddress;
use board::contract::interface::BoardABIDispatcher;

#[starknet::interface]
pub trait IParticipant<TState> {
    fn board(self: @TState) -> BoardABIDispatcher;
}
