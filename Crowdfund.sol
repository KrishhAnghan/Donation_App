// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Donation {
    address public owner;
    uint public totalDonations;
    
    struct Donor {
        address donorAddress;
        uint amount;
    }

    mapping(uint => Donor) public donors;
    uint public donorCount;

    event Donated(address indexed donor, uint amount);
    event Withdrawn(address indexed owner, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than 0");
        donorCount++;
        donors[donorCount] = Donor(msg.sender, msg.value);
        totalDonations += msg.value;
        emit Donated(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance > 0, "No balance to withdraw");
        payable(owner).transfer(address(this).balance);
        emit Withdrawn(owner, address(this).balance);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function getDonor(uint id) external view returns (address, uint) {
        Donor memory d = donors[id];
        return (d.donorAddress, d.amount);
    }
}