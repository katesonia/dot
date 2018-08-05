pragma solidity ^0.4.0;

contract VoteProposal {

    struct Voter {
        bool voted;
        uint8 vote;
    }
    
    struct Proposal {
        //string name;
        //string description;
        uint voteCount;
        uint proposedFund;
        address initiator;
        bool fundIssued;
    }

    //address chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    function propose(uint proposedFund) public returns (uint) {
        proposals.push(Proposal(0, proposedFund, msg.sender, false));
        return proposals.length;
    }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        // There is no proposal to vote.
        //require(proposals.length != 0);
        
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        
        uint balance = 1000000000000;
        //No right to vote if voter has no balance.
        //if (balance == 0) return;
        
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += balance;
    }

    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
    
    //Generate tokens and issue fund to winning proposal.
    function issueFundToWinningProposal() public {
        Proposal storage proposal = proposals[winningProposal()];
        if (proposal.fundIssued) return;
        
        // dotTokenContract.generateTokens(proposal.initiator, proposal.proposedFund);
        proposal.fundIssued = true;
    }
}