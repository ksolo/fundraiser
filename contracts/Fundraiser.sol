pragma solidity ^0.4.19;

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
    uint256 exchange;
    uint256 value;
  }

  // number of donations received (really just used to make testing easier)
  uint256 public donationsCount;

  // retain donation indexes for each address
  mapping(address => uint256[]) private donationIndexes;

  // retain all the donation records
  Donation[] public donations;

  // notifies the client that the donation has been completed
  event DonationReceived();

  // pass donation records to front-end
  event FetchedDonations(Donation[] donations);

  // update the organization's address
  function setOrganization(address orgAddress) public onlyOwner {
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

  // currently cannot return a collection of structs from a contract
  // this function emits and event that will contain the data
  function emitDonations(address donor) public {
    uint256[] storage donorIndexes = donationIndexes[donor];
    Donation[] memory donationRecords = new Donation[](donorIndexes.length);

    for(uint256 i = 0; i < donorIndexes.length; i++) {
      donationRecords[i] = donations[donorIndexes[i]];
    }

    FetchedDonations(donationRecords);
  }
}
