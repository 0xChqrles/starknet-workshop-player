#[starknet::interface]
pub trait IBehaver<TState> {
    fn steal(ref self: TState, name: felt252);
    fn give(ref self: TState, name: felt252);
}
