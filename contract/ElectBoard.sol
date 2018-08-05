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
    Candidate[3] topCandidates;

    /// Create a new ballot with $(_numProposals) different proposals.
    // The election only lasts for 2 days.
    constructor(address _dotTokenAddr) public {
        dotTokenContract = DotToken(_dotTokenAddr);
    }

    /// Give vote(the weight is the balance of the voter) to candidate $(toProposal).
    function vote(address cand) public {
        Voter storage sender = voters[msg.sender];
        uint voterBalance = dotTokenContract.balanceOf(msg.sender);
        
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

    // Get the current top 10 candidates.
    function getBoardMembers() public returns (address[3]) {
        address[3] storage boardMembers;
        for (uint8 i = 0; i < topCandidates.length; i++) {
            if (topCandidates[i].candidateAddr != address(0)) {
                boardMembers[i] = topCandidates[i].candidateAddr;
            }
        }
        return boardMembers;
    }
}
