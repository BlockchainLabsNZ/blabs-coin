pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract BlabsCoin is StandardToken, Ownable {

  // Token properties
  string public constant name = 'BlabsCoin';
  string public constant symbol = 'BLABS';
  uint8 public constant decimals = 18;

  string[] private gratitudeMessages = [
    "Thank you, it won't go to waste ;)",
    "Great investment!",
    "Congratulations, you've made the right choice"
  ];
  uint private thanksCounter = 0;

  uint public constant BILLION_COINS = 1000 * (10**6) * (10**18);

  // Constructor
  function BlabsCoin() public {
    totalSupply_ = BILLION_COINS;
    balances[this] = totalSupply_;
    Transfer(0x0, this, totalSupply_);
  }

  function coinFaucet() public {
    uint coinDrip = 500000 * (10**18);
    balances[this] -= coinDrip;
    balances[msg.sender] += coinDrip;
    Transfer(this, msg.sender, coinDrip);
  }

  event DonationAccepted(
    uint donationAmountInWei,
    address indexed generousHumanOrBot,
    string gratitudeMessage
  );
  function() public payable {
    DonationAccepted(msg.value, msg.sender, gratitudeMessages[thanksCounter % gratitudeMessages.length]);
    thanksCounter = thanksCounter++;
  }

  // If someone took all the tokens, we create more..
  function printMoney() public onlyOwner {
    totalSupply_ += BILLION_COINS;
    balances[this] += BILLION_COINS;
    Transfer(0x0, this, totalSupply_);
  }

  // Claiming donations or lost tokens
  function claim(address _token) public onlyOwner {
    if (_token == 0x0) {
      owner.transfer(this.balance);
      return;
    }

    ERC20Basic token = ERC20Basic(_token);
    uint balance = token.balanceOf(this);
    token.transfer(owner, balance);
  }

}
