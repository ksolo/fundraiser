pragma solidity ^0.4.19;

contract Fundraiser {
  address public manager;
  address public organization;

  function Fundraiser() public {
    manager = msg.sender;
  }

  function setOrganization(address orgAddress) public {
    require(manager == msg.sender);
    organization = orgAddress;
  }
}
