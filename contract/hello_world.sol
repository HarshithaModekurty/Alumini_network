// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlumniNetworkDAO {
    struct Initiative {
        uint id;
        string title;
        string description;
        uint voteCount;
        bool executed;
    }

    uint public nextInitiativeId;
    mapping(uint => Initiative) public initiatives;

    event InitiativeProposed(uint id, string title);
    event VoteCasted(uint initiativeId);
    event InitiativeExecuted(uint id);

    // Propose a new initiative
    function proposeInitiative(string memory _title, string memory _description) public {
        initiatives[nextInitiativeId] = Initiative({
            id: nextInitiativeId,
            title: _title,
            description: _description,
            voteCount: 0,
            executed: false
        });
        emit InitiativeProposed(nextInitiativeId, _title);
        nextInitiativeId++;
    }

    // Vote for an initiative
    function voteForInitiative(uint _initiativeId) public {
        Initiative storage initiative = initiatives[_initiativeId];
        require(!initiative.executed, "Initiative already executed");
        initiative.voteCount++;
        emit VoteCasted(_initiativeId);
    }

    // Execute an initiative
    function executeInitiative(uint _initiativeId) public {
        Initiative storage initiative = initiatives[_initiativeId];
        require(initiative.voteCount > 0, "No votes to execute");
        require(!initiative.executed, "Already executed");

        initiative.executed = true;
        emit InitiativeExecuted(_initiativeId);
    }

    // Get details of an initiative
    function getInitiativeDetails(uint _initiativeId) public view returns (string memory, string memory, uint, bool) {
        Initiative memory initiative = initiatives[_initiativeId];
        return (initiative.title, initiative.description, initiative.voteCount, initiative.executed);
    }
}