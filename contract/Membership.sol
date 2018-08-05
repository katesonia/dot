pragma solidity ^0.4.23;

import "./DotToken.sol";


contract Membership {
    struct Member {
		address addr;
		string name;
		bool isBoardMember;
	}

    DotToken public tokenContract;
    mapping(address => Member) public memberInfo;
    
    constructor(address tokenAddress) public {
        tokenContract = DotToken(tokenAddress);
    }
    
    
    function checkMembership(address addr) public view returns (bool){
        return tokenContract.hasAccomplishment(addr);
    }
    
    
    function setMemberInfo(string name, bool isBoard) public {
        Member storage member = memberInfo[msg.sender];
        member.addr = msg.sender;
        member.name = name;
        member.isBoardMember = isBoard;
        return;
    }
    
    function getMemberInfo(address addr) public view returns (address, string, bool) {
        require(checkMembership(addr) == true);
        return (memberInfo[addr].addr, memberInfo[addr].name, memberInfo[addr].isBoardMember);
    }
}
