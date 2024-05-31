#[starknet::interface]
pub trait IBehaver<TState> {
    fn give(ref self: TState, name: felt252);
    fn steal(ref self: TState, name: felt252);
}
