#[starknet::contract]
pub mod Player {
    use player::components::{BehaverComponent, ReacterComponent, ParticipantComponent};
    use openzeppelin::access::ownable::OwnableComponent;
    use player::components::behaver::interface::IBehaver;
    use player::components::reacter::interface::{LosingStrategy, ReceivingStrategy};
    use starknet::ContractAddress;

    component!(path: BehaverComponent, storage: behaver, event: BehaverEvent);
    component!(path: ReacterComponent, storage: reacter, event: ReacterEvent);
    component!(path: ParticipantComponent, storage: participant, event: ParticipantEvent);

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    // Reacter
    #[abi(embed_v0)]
    impl ReacterImpl = ReacterComponent::ReacterImpl<ContractState>;
    impl ReacterInternalImpl = ReacterComponent::InternalImpl<ContractState>;

    // Participant
    #[abi(embed_v0)]
    impl ParticipantImpl = ParticipantComponent::ParticipantImpl<ContractState>;
    impl ParticipantInternalImpl = ParticipantComponent::InternalImpl<ContractState>;

    // Ownable Mixin
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    //
    // Storage
    //

    #[storage]
    struct Storage {
        #[substorage(v0)]
        behaver: BehaverComponent::Storage,
        #[substorage(v0)]
        reacter: ReacterComponent::Storage,
        #[substorage(v0)]
        participant: ParticipantComponent::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
    }

    //
    // Events
    //

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        BehaverEvent: BehaverComponent::Event,
        #[flat]
        ReacterEvent: ReacterComponent::Event,
        #[flat]
        ParticipantEvent: ParticipantComponent::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    //
    // Constructor
    //

    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, board_address: ContractAddress, owner: ContractAddress) {
        self.ownable.initializer(:owner);
        self.reacter.initializer();
        self.participant.initializer(:name, :board_address);
    }

    //
    // Participant override
    //

    #[abi(embed_v0)]
    impl Behaver of IBehaver<ContractState> {
        fn steal(ref self: ContractState, name: felt252) {
            self.ownable.assert_only_owner();
            self.behaver.steal(:name);
        }

        fn give(ref self: ContractState, name: felt252) {
            self.ownable.assert_only_owner();
            self.behaver.give(:name);
        }
    }

    //
    // Strategy selection
    //

    #[abi(embed_v0)]
    fn set_losing_strategy(ref self: ContractState, strategy: LosingStrategy) {
        self.ownable.assert_only_owner();
        self.reacter._set_losing_strategy(:strategy);
    }

    #[abi(embed_v0)]
    fn set_receiving_strategy(ref self: ContractState, strategy: ReceivingStrategy) {
        self.ownable.assert_only_owner();
        self.reacter._set_receiving_strategy(:strategy);
    }
}
