pragma solidity ^0.4.19;

contract Fundraiser {
  address public manager;
  address public organization;

  function Fundraiser() public {
    manager = msg.sender;
  }

  modifier restricted() {
    require(manager == msg.sender);
    _;
  }

  function setOrganization(address orgAddress) public restricted {
    organization = orgAddress;
  }

  function donate(uint exchangeRate) public payable {
    organization.transfer(msg.value);
  }
}
