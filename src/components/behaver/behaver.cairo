#[starknet::component]
pub mod BehaverComponent {
    use board::contract::interface::BoardABIDispatcherTrait;
    use player::components::behaver::interface::IBehaver;
    use player::components::ParticipantComponent;

    //
    // Storage
    //

    #[storage]
    struct Storage {}

    //
    // IBehaver impl
    //

    #[embeddable_as(BehaverImpl)]
    impl Behaver<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        impl Participant: ParticipantComponent::HasComponent<TContractState>,
    > of IBehaver<ComponentState<TContractState>> {
        fn steal(ref self: ComponentState<TContractState>, name: felt252) {
            // getting board
            let mut participant = get_dep_component_mut!(ref self, Participant);
            let board = participant.board.read();

            // stealing
            board.steal(:name);
        }

        fn give(ref self: ComponentState<TContractState>, name: felt252) {
            // getting board
            let mut participant = get_dep_component_mut!(ref self, Participant);
            let board = participant.board.read();

            // giving
            board.give(:name);
        }
    }
}
