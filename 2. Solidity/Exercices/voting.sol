pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

    struct Proposal {
        string description;
        uint256 voteCount;
    }

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );
    event ProposalRegistered(uint256 proposalId);
    event Voted(address voter, uint256 proposalId);

    uint256 public winningProposalId;
    WorkflowStatus public status;
    Proposal[] public proposals;
    mapping(address => Voter) public voters;

    modifier onlyRegistered() {
        require(voters[msg.sender].isRegistered, "you are not registered");
        _;
    }

    constructor() Ownable() {
        proposals.push(Proposal("vote blanc", 0));
    }

    function registerVoter(address _address) public onlyOwner {
        require(
            status == WorkflowStatus.RegisteringVoters,
            "you are allowed to Register Voters only at RegisteringVoters session"
        );

        voters[_address] = Voter(true, false, 0);

        emit VoterRegistered(_address);
    }

    function changeStatus(WorkflowStatus _status) public onlyOwner {
        emit WorkflowStatusChange(status, _status);
        status = _status;
    }

    function registerProposal(string memory _description)
        public
        onlyRegistered
    {
        require(
            status == WorkflowStatus.ProposalsRegistrationStarted,
            "you are allowed to add Proposals only at ProposalsRegistrationStarted session"
        );

        proposals.push(Proposal(_description, 0));

        emit ProposalRegistered(proposals.length - 1);
    }

    function registerVote(uint256 _proposalId) public onlyRegistered {
        require(
            status == WorkflowStatus.VotingSessionStarted,
            "you are allowed to Vote only at VotingSessionStarted session"
        );
        require(!voters[msg.sender].hasVoted, "you have already voted");

        proposals[_proposalId].voteCount++;
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;

        emit Voted(msg.sender, _proposalId);
    }

    /*
     * La proposition gagnante est celle qui possède le plus de votes
     * Afin de favoriser l'action à la réflexion, s'il y a égalité
     * le premier à avoir fait sa proposition est déclaré vainqueur
     */
    function countingVotes() public onlyOwner {
        require(
            status == WorkflowStatus.VotingSessionEnded,
            "you are allowed to count only at VotingSessionEnded session."
        );

        uint256 i = 0;
        uint256 leaderCount = 0;
        uint256 leaderCountId = 0;
        for (i; i < proposals.length; i++) {
            if (proposals[i].voteCount > leaderCount) {
                leaderCount = proposals[i].voteCount;
                leaderCountId = i;
            }
        }

        winningProposalId = leaderCountId;
    }

    function getWinnerDetails()
        external
        view
        onlyRegistered
        returns (string memory)
    {
        require(
            status == WorkflowStatus.VotesTallied,
            "you are allowed to see winner details only at VotesTallied session."
        );
        return proposals[winningProposalId].description;
    }

    receive() external payable {}

    fallback() external payable {}
}