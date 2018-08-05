pragma solidity ^0.4.23;

import "./DotToken.sol";


contract Membership {
	struct Member {
		address addr;
		string name;
		bool isBoardMember;
	}

	DotToken public tokenContract;
  mapping(address => Member) memberInfo;
    
  constructor(address tokenAddress) public {
      tokenContract = DotToken(tokenAddress);
  }
    
    
  function check_membership(address addr) public view returns (bool){
      if (tokenContract.accomplishmentOf(addr)==0){
          return false;
      }
      return true;
  }
    
    
  function set_member_info(address addr, string name, bool isBoard) public{
      memberInfo[addr] = Member(addr, name, isBoard);
      return;
  }
    
  function get_member_info(address addr) public view returns (address, string, bool) {
      require(check_membership(addr) == true);
      return(memberInfo[addr].addr, memberInfo[addr].name, memberInfo[addr].isBoardMember);
  }
}
