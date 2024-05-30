#[starknet::interface]
pub trait IParticipant<TState> {
    fn name(self: @TState) -> felt252;
}
