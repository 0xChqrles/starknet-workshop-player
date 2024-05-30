#[starknet::component]
pub mod ParticipantComponent {
    use player::components::participant::interface::IParticipant;
    use starknet::ContractAddress;
    use board::contract::interface::{BoardABIDispatcher, BoardABIDispatcherTrait};

    //
    // Storage
    //

    #[storage]
    struct Storage {
        board: BoardABIDispatcher,
    }

    //
    // IParticipant impl
    //

    #[embeddable_as(ParticipantImpl)]
    impl Participant<
        TContractState, +HasComponent<TContractState>,
    > of IParticipant<ComponentState<TContractState>> {
        fn board(self: @ComponentState<TContractState>) -> BoardABIDispatcher {
            self.board.read()
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
            let board = BoardABIDispatcher { contract_address: board_address };

            // register to the board
            board.register(:name);

            // save the board
            self.board.write(board);
        }
    }
}
