#[starknet::component]
pub mod ReacterComponent {
    use player::components::participant::interface::IParticipant;
    use player::components::ParticipantComponent;
    use player::components::reacter::interface::{IReacter, LosingStrategy, ReceivingStrategy};
    use starknet::get_caller_address;

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
            self._assert_caller_is_board();
            self.losing_strategy.read()
        }

        fn receive(self: @ComponentState<TContractState>) -> ReceivingStrategy {
            self._assert_caller_is_board();
            self.receiving_strategy.read()
        }
    }

    //
    // Internal impl
    //

    #[generate_trait]
    pub impl InternalImpl<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        impl Participant: ParticipantComponent::HasComponent<TContractState>,
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>) {
            // Init with no strategies
            self._set_losing_strategy(LosingStrategy::None);
            self._set_receiving_strategy(ReceivingStrategy::None);
        }

        fn _assert_caller_is_board(self: @ComponentState<TContractState>) {
            // getting the board
            let mut participant = get_dep_component!(self, Participant);
            let board_address = participant.board().contract_address;

            // assert the caller is the board
            assert(get_caller_address() == board_address, 'Caller is not the board');
        }

        fn _set_losing_strategy(ref self: ComponentState<TContractState>, strategy: LosingStrategy) {
            self.losing_strategy.write(strategy);
        }

        fn _set_receiving_strategy(ref self: ComponentState<TContractState>, strategy: ReceivingStrategy) {
            self.receiving_strategy.write(strategy);
        }
    }
}
