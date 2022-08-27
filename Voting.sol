// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;
contract Voting
{
    address immutable owner;
    mapping(address=>bool) voted; // Whether voter voted or not
    mapping(address=>uint) voting; // Whether voter payed the voting fee
    uint votingtimeperiod; // store the time at which contract was deployed
    constructor()
    {
        owner = payable (msg.sender); // contract could bbe send ethers as well as withdrawn
        votingtimeperiod = block.timestamp + 5 minutes;
    }
    function PayVoteFee() external payable 
    {
        require(msg.sender  != owner,"Owner Cannot pay ... :-) ");
        require(msg.value == 1,"YOU NEED TO PAY  EXCATLY 1 ETHER ");
        require(voting[msg.sender] < 1,"You Didn't Payed the Voting Fee");
        voting[msg.sender] = 1;
        (bool success,) = msg.sender.call{value:1 ether}("") ;
         Require(success,"transaction failed");
}
    function Vote() public 
    {
        require(msg.sender  != owner,"Owner cannot vote");
        require(block.timestamp < votingtimeperiod,"OOPs ..!! Voting finished Surely come in  the next Poll");
        require(voting[msg.sender] == 1,"YOU DIDN'T PAY THE VOTING FEE");
        require(voted[msg.sender] == false,"You Already USED YOUR VOTE");
        voted[msg.sender] = true;
    }
    function checkcontractbalance() public view returns(uint)
    {
        require(msg.sender == owner,"only owner are allowed to check the balance");
        return address(this).balance;
    }
    function withdraw() public {
        require(msg.sender == owner,"Only Owners are able to verify");
        (bool success,) = owner.call{value:(address(this).balance)}("");
        require(success,"Transaction reverted Failed to send");
    }
    receive()  payable external
    {

    }
}
