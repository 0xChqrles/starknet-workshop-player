use board::strategies::{ReceivingStrategy, LosingStrategy};

#[starknet::interface]
pub trait IReacter<TState> {
    fn receive(self: @TState) -> ReceivingStrategy;
    fn lose(self: @TState) -> LosingStrategy;
}
