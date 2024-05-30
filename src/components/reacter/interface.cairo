pub use board::strategies::{LosingStrategy, ReceivingStrategy};

#[starknet::interface]
pub trait IReacter<TState> {
    fn lose(self: @TState) -> LosingStrategy;
    fn receive(self: @TState) -> ReceivingStrategy;
}
