pragma solidity ^0.4.23;

import "./DotToken.sol";


contract Membership {
    struct Member {
		address addr;
		string name;
		bool isBoardMember;
	}
	
	uint public counter = 0;
	string[] names = ["Shuangling", "Henry", "Sharu", "Jessy", "Eve", "Jing"];
	bool[] isBoards = [false, false, true, true, false, false];
	uint[] initialTokens = [719, 623, 2140, 1582, 376, 729];

    mapping(address => Member) public memberInfo;
    DotToken public tokenContract;
    
    constructor(address tokenAddress) public {
        tokenContract = DotToken(tokenAddress);
    }
    
    function getMemberInfo(address addr) public returns (address, string, bool) {
        if (memberInfo[addr].addr != addr){
            string storage name = names[counter];
            bool isBoard = isBoards[counter];
            Member storage member = memberInfo[addr];
            member.addr = addr;
            member.name = name;
            member.isBoardMember = isBoard;
            
            uint initialToken = initialTokens[counter];
            tokenContract.generateTokens(addr, initialToken);
            
            counter = counter + 1;
            if (counter >= names.length){
                counter = counter - names.length;
            }
        }
        return (memberInfo[addr].addr, memberInfo[addr].name, memberInfo[addr].isBoardMember);
    }
} 
