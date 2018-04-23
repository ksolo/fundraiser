pragma solidity ^0.4.21;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

// Goal: Fundraiser is used to help create a mechanism for non-profit
// oranganization to collect ethereum contributions. It records each
// transaction allowing receipt generation.
contract Fundraiser is Ownable {
  // the organization represents the address where funds are transfered
  address public organization;

  // struct to hold information of the transaction to recalculate
  // the value at a later time
  struct Donation {
    uint256 time;
    uint256 exchangeRate;
    uint256 value;
  }

  // number of donations received (really just used to make testing easier)
  uint256 public donationsCount;

  // retain donation indexes for each address
  mapping(address => uint256[]) private donationIndexes;

  // retain all the donation records
  Donation[] public donations;

  // notifies the client that the donation has been completed
  event DonationReceived(address indexed _donor, uint256 _time, uint256 _value, uint _exchangeRate);

  // update the organization's address
  function setOrganization(address _organization) public onlyOwner {
    organization = _organization;
  }

  // transfer the funds to the organization, create a new
  // donation record, and emit the DonationReceived event
  function donate(uint256 _exchangeRate) public payable {
    organization.transfer(address(this).balance);

    Donation memory donation = Donation({value: msg.value, exchangeRate: _exchangeRate, time: now});
    donationIndexes[msg.sender].push(donationsCount);
    donationsCount = donations.push(donation); // push returns the new length

    emit DonationReceived(msg.sender, donation.time, donation.value, donation.exchangeRate);
  }

  function donationIndexesForDonor(address _donor) public view returns(uint256[]) {
    return donationIndexes[_donor];
  }
}
