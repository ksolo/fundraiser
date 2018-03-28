const Fundraiser = artifacts.require('./Fundraiser.sol');

contract('Fundraiser', (accounts) => {
  let fundraiser;

  beforeEach(async () => {
    fundraiser = await Fundraiser.deployed();
  });

  it('deploys', async () => {
    assert(fundraiser, 'instance has been deployed');
  });

  it('initializes with a manager', async () => {
    const address = await fundraiser.manager();

    assert(parseInt(address), 'has a manager after intialization');
  });

  contract('#setOrganization(address orgAddress)', () => {
    it('requires manager to set organization', async () => {
      const organizationAddress = accounts[1];
      const manager = accounts[0];

      try {
        await fundraiser.setOrganization(organizationAddress, { from: manager });
        assert(true, 'only a manager can update the organization');
      } catch(err) {
        assert(false, 'manager did not match sender');
      }
    });

    it('sets organization', async () => {
      const manager = accounts[0];
      const newOrganization = accounts[2];
      const oldOrganization = await fundraiser.organization();

      await fundraiser.setOrganization(newOrganization, { from: manager });
      const currentOrganization = await fundraiser.organization();

      assert.equal(currentOrganization, newOrganization, 'updated organization');
      assert.notEqual(currentOrganization, oldOrganization);
    });
  });

  contract('#donate(uint currentExchangeRate)', async () => {
    it('transfers ether to organization', async () => {
      await fundraiser.setOrganization(accounts[2], { from: accounts[0] });
      const oldBalance = await web3.eth.getBalance(accounts[2]);

      await fundraiser.donate.sendTransaction(54200, { from: accounts[4], value: '50000000' });

      const newBalance = await web3.eth.getBalance(accounts[2]);
      assert(newBalance.gt(oldBalance), 'new balance is greater than old balance');
    });

    it('emits DonationReceived event', async () => {
        const transaction = await fundraiser.donate(54200, { from: accounts[4], value: '5000000'})
        assert.equal(transaction.logs[0].event, 'DonationReceived');
    });


    xit('adds a new donation record to the contract', async () => {});
  });
});
