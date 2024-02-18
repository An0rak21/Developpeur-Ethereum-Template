// SPDX-License-Identifier: MIT

pragma solidity >= 0.8 < 0.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    // Status de la session de vote
    enum WorkflowStatus {   
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }   
    // Struture de l'électeur
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

    // Structure de la proposition
    struct Proposal {
        string description;
        uint256 voteCount;
    }

    // Déclaration des events
    event VoterRegistered(address voterAddress);    // Event pour l'enregistrement de l'électeur
    event WorkflowStatusChange(                     // Event pour le changement de status
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );
    event ProposalRegistered(uint256 proposalId);   // Event pour l'enregistrement de la proposition
    event Voted(address voter, uint256 proposalId); // Event pour le vote

    uint256 public winningProposalId;
    WorkflowStatus public status;
    Proposal[] public proposals;
    mapping(address => Voter) public voters;

    // Fonction pour enregistrer un électeur
    function registerVoter(address _voterAddress) public onlyOwner {
        require(status == WorkflowStatus.RegisteringVoters, "Registration is not open");    // Vérification du status de la session
        require(!voters[_voterAddress].isRegistered, "Voter already registered");       // Vérification de l'enregistrement de l'électeur afin qu'il ne s'enregistre pas deux fois
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);    // Envoi de l'event
    }

    // Fonction pour démarrer la session d'enregistrement des propositions
    function startProposalRegistration() public onlyOwner {
        require(status == WorkflowStatus.RegisteringVoters, "Cannot start proposal registration");  // Vérification du status de la session
        status = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, status);    // Envoi de l'event
    }

    // Fonction pour enregistrer une proposition
    function registerProposal(string memory _description) public {
        require(status == WorkflowStatus.ProposalsRegistrationStarted, "Cannot register proposal");  // Vérification du status de la session
        proposals.push(Proposal(_description, 0));
        emit ProposalRegistered(proposals.length - 1);  // Envoi de l'event
    }

    // Fonction pour terminer la session d'enregistrement des propositions
    function endProposalRegistration() public onlyOwner {
        require(status == WorkflowStatus.ProposalsRegistrationStarted, "Cannot end proposal registration");  // Vérification du status de la session
        status = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, status);    // Envoi de l'event
    }

    // Fonction pour démarrer la session de vote
    function startVotingSession() public onlyOwner {
        require(status == WorkflowStatus.ProposalsRegistrationEnded, "Cannot start voting session");  // Vérification du status de la session
        status = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, status);    // Envoi de l'event
    }

    // Fonction pour voter
    function vote(uint256 _proposalId) public {
        require(status == WorkflowStatus.VotingSessionStarted, "Cannot vote");  // Vérification du status de la session
        require(voters[msg.sender].isRegistered, "You are not registered");    // Vérification de l'enregistrement de l'électeur
        require(!voters[msg.sender].hasVoted, "You have already voted");       // Vérification que l'électeur n'a pas déjà voté
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;
        emit Voted(msg.sender, _proposalId);    // Envoi de l'event
    }

    // Fonction pour terminer la session de vote
    function endVotingSession() public onlyOwner {
        require(status == WorkflowStatus.VotingSessionStarted, "Cannot end voting session");  // Vérification du status de la session
        status = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, status);    // Envoi de l'event
    }

    // Fonction pour compter les votes
    function tallyVotes() public onlyOwner {
        require(status == WorkflowStatus.VotingSessionEnded, "Cannot tally votes");  // Vérification du status de la session
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
        status = WorkflowStatus.VotesTallied;
    }

    // Fonction pour obtenir le nombre de propositions
    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }

    // Fonction pour obtenir le nombre de votes d'une proposition
    function getProposalVoteCount(uint256 _proposalId) public view returns (uint256) {
        return proposals[_proposalId].voteCount;
    }

    // Fonction pour obtenir la description d'une proposition
    function getProposalDescription(uint256 _proposalId) public view returns (string memory) {
        return proposals[_proposalId].description;
    }

    // Fonction pour obtenir le status de la session
    function getStatus() public view returns (WorkflowStatus) {
        return status;
    }

    // Fonction pour obtenir le gagnant
    function getWinner() public view returns (string memory) {
        return proposals[winningProposalId].description;
    }

    // Fonction pour obtenir le nombre de votes du gagnant
    function getWinnerVoteCount() public view returns (uint256) {
        return proposals[winningProposalId].voteCount;
    }

    // Fonction pour obtenir le nombre de votes de l'électeur
    function getVoterVoteCount(address _voterAddress) public view returns (uint256) {
        return proposals[voters[_voterAddress].votedProposalId].voteCount;
    }

    // Fonction pour obtenir la description de la proposition votée par l'électeur
    function getVoterVoteDescription(address _voterAddress) public view returns (string memory) {
        return proposals[voters[_voterAddress].votedProposalId].description;
    }

    // Fonction pour obtenir le status de l'électeur
    function getVoterStatus(address _voterAddress) public view returns (bool, bool, uint256) {
        return (
            voters[_voterAddress].isRegistered,
            voters[_voterAddress].hasVoted,
            voters[_voterAddress].votedProposalId
        );
    }

    


}