pragma solidity ^0.4.19;

// Goal: Fundraiser is used to help create a mechanism for non-profit
// oranganization to collect ethereum contributions. It records each
// transaction allowing receipt generation.
contract Fundraiser {
  // the manager is the person that is administering the contract
  // and deploying it on behalf of the organization
  address public manager;

  // the organization represents the address where funds are transfered
  address public organization;

  // struct to hold information of the transaction to recalculate
  // the value at a later time
  struct Donation {
    uint256 time;
    uint256 exchange;
    uint256 value;
  }

  // number of donations received (really just used to make testing easier)
  uint256 public donationsCount;

  // retain donation indexes for each address
  mapping(address => uint[]) private donationIndexes;

  // retain all the donation records
  Donation[] public donations;

  // notifies the client that the donation has been completed
  event DonationReceived();

  // initialize the manager at time of deployment
  function Fundraiser() public {
    manager = msg.sender;
  }

  // used to limit certain actions to the manager
  modifier restricted() {
    require(manager == msg.sender);
    _;
  }

  // update the organization's address
  function setOrganization(address orgAddress) public restricted {
    organization = orgAddress;
  }

  // transfer the funds to the organization, create a new
  // donation record, and emit the DonationReceived event
  function donate(uint256 exchangeRate) public payable {
    organization.transfer(address(this).balance);

    Donation memory donation = Donation({value: msg.value, exchange: exchangeRate, time: now});
    donationIndexes[msg.sender].push(donationsCount);
    donationsCount = donations.push(donation); // push returns the new length

    DonationReceived();
  }
}
