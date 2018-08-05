pragma solidity ^0.4.17;

contract Balance {
    uint public amount;
    address public member;
    
    // Get balance
    function getBalance() public returns (uint) {
      amount = 199;
      return 201;
    }
    
    // Set member address
    function setMember() public {
      member = msg.sender;
    }
}