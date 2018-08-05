//pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

import "./DotToken.sol";


contract ElectBoard {

    DotToken public dotTokenContract;

    struct Voter {
        bool voted;
        address vote;
    }
    
    struct Candidate {
        address candidateAddr;
        uint voteCount;
    }

    mapping(address => Voter) voters;
    mapping(address => Candidate) candidates;
    Candidate[10] topCandidates;
    uint public startDate;
    uint public endDate;

    /// Create a new ballot with $(_numProposals) different proposals.
    // The election only lasts for 2 days.
    constructor(address _dotTokenAddr) public {
        dotTokenContract = DotToken(_dotTokenAddr);
        startDate = now;
        endDate = now + 2 days;
    }

    /// Give vote(the weight is the balance of the voter) to candidate $(toProposal).
    function vote(address cand) public {
        Voter storage sender = voters[msg.sender];
        uint candidateBalance = dotTokenContract.balanceOf(cand);
        // No right to be voted if candidate doesn't have balance.
        if (sender.voted || candidateBalance == 0) return;
        
        uint voterBalance = dotTokenContract.balanceOf(msg.sender);
        //No right to vote if voter has no balance.
        if (voterBalance == 0) return;
        
        sender.voted = true;
        sender.vote = cand;
        candidates[cand].voteCount += voterBalance;
        for (uint8 i = 0; i < topCandidates.length; i++) {
            if (candidates[cand].voteCount > topCandidates[i].voteCount) {
                topCandidates[i] = candidates[cand];
                break;
            } 
        }
    }

    function getBoardMembers() public constant returns (Candidate[10]) {
        return topCandidates;
    }
}
