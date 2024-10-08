module MyModule::CrowdfundingPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    /// Struct representing a crowdfunding project.
    struct Project has store, key {
        creator: address,          // Address of the project creator
        name: vector<u8>,          // Name of the project
        goal_amount: u64,          // Goal amount for the project
        total_funded: u64,         // Total amount funded by contributors
        is_milestone_met: bool,    // Whether a milestone is met
    }

    /// Function to create a new crowdfunding project.
    public fun create_project(creator: &signer, name: vector<u8>, goal_amount: u64) {
        let project = Project {
            creator: signer::address_of(creator),
            name,
            goal_amount,
            total_funded: 0,
            is_milestone_met: false,
        };
        move_to(creator, project);
    }

    /// Function for users to contribute to a project.
    public fun contribute_to_project(contributor: &signer, project_creator: address, amount: u64) acquires Project {
        let project = borrow_global_mut<Project>(project_creator);

        // Ensure the milestone is not met yet
        assert!(!project.is_milestone_met, 1);

        // Update the total amount funded
        project.total_funded = project.total_funded + amount;
    }
}
