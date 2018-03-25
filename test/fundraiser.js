const Fundraiser = artifacts.require('./Fundraiser.sol');

contract('Fundraiser', () => {
  it('deploys', async () => {
    const instance = await Fundraiser.new();
    assert(instance);
  });
});
