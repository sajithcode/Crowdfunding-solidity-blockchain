// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Crowdfunding {
    string public name;
    string public description;
    uint256 public goal;
    uint256 public deadline;
    address public owner;

    struct Tier {
        string name;
        uint256 amount;
        uint256 backers;
    }

    Tier[] public tiers;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _duratationInDays
    ) {
        name = _name;
        description = _description;
        goal = _goal;
        deadline = block.timestamp + (_duratationInDays * 1 days);
        owner = msg.sender;
    }

    function fund(uint256 _tierIndex)  public payable {
        require(block.timestamp < deadline, "Campaign has ended.");
        require(_tierIndex < tiers.length, "Invalid tier.");
        require(msg.value == tiers[_tierIndex].amount, "Invalid amount.");

        tiers[_tierIndex].backers++;
    }

    function addTier(
        string memory _name,
        uint256 _amount
       
    ) public onlyOwner  {
        require(_amount > 0, "Amount must be greater than 0.");
        tiers.push(Tier(_name, _amount, 0));
    }

    function removeTier(uint256 _index) public onlyOwner {
        require(_index < tiers.length, "Tiers does not exit");
        tiers[_index] = tiers[tiers.length - 1];
        tiers.pop();
    }

    function withdraw()  public onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw funds.");
        require(address(this).balance >= goal, "Funding goal has not been reached.");

        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        payable(owner).transfer(balance);
    }
    
    function getContractBalance()  public view returns (uint256) {
        return address(this).balance;
        
    }
}