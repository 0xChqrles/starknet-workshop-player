#[starknet::component]
pub mod ParticipantComponent {
    use player::components::participant::interface::IParticipant;
    use starknet::ContractAddress;
    use board::contract::interface::BoardABIDispatcher;

    //
    // Storage
    //

    #[storage]
    struct Storage {
        name: felt252,
        board: BoardABIDispatcher,
    }

    //
    // IParticipant impl
    //

    #[embeddable_as(ParticipantImpl)]
    impl Participant<
        TContractState, +HasComponent<TContractState>,
    > of IParticipant<ComponentState<TContractState>> {
        fn name(self: @ComponentState<TContractState>) -> felt252 {
            self.name.read()
        }
    }

    //
    // Internal impl
    //

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initializer(
            ref self: ComponentState<TContractState>, name: felt252, board_address: ContractAddress
        ) {
            self.name.write(name);
            self.board.write(BoardABIDispatcher { contract_address: board_address });
        }
    }
}
