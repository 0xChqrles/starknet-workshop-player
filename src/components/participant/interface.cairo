use starknet::ContractAddress;

#[starknet::interface]
pub trait IParticipant<TState> {
    fn register(ref self: TState, board_address: ContractAddress, name: felt252);
}
