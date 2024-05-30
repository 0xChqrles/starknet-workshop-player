#[starknet::component]
pub mod ReacterComponent {
    use player::components::ParticipantComponent;
    use player::components::reacter::interface::{IReacter, LosingStrategy, ReceivingStrategy};

    //
    // Storage
    //

    #[storage]
    struct Storage {
        losing_strategy: LosingStrategy,
        receiving_strategy: ReceivingStrategy,
    }

    //
    // IReacter impl
    //

    #[embeddable_as(ReacterImpl)]
    impl Reacter<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        impl Participant: ParticipantComponent::HasComponent<TContractState>,
    > of IReacter<ComponentState<TContractState>> {
        fn lose(self: @ComponentState<TContractState>) -> LosingStrategy {
            self.losing_strategy.read()
        }

        fn receive(self: @ComponentState<TContractState>) -> ReceivingStrategy {
            self.receiving_strategy.read()
        }
    }

    //
    // Internal impl
    //

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>) {
            // Init with no strategies
            self._set_losing_strategy(LosingStrategy::None);
            self._set_receiving_strategy(ReceivingStrategy::None);
        }

        fn _set_losing_strategy(ref self: ComponentState<TContractState>, strategy: LosingStrategy) {
            self.losing_strategy.write(strategy);
        }

        fn _set_receiving_strategy(ref self: ComponentState<TContractState>, strategy: ReceivingStrategy) {
            self.receiving_strategy.write(strategy);
        }
    }
}
