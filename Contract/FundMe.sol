// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//Also we can import the AggregartorV3Interface from chainlink repo

import {PriceConvertor} from "./PriceConvertor.sol";
//from where i got the interface, if you are cursious about it
//here is the link: https://github.com/smartcontractkit/smart-contract-examples/blob/630d83e9be2ee27625b13986c8d9938c4523397d/pricefeed-golang/aggregatorv3/AggregatorV3Interface.sol
//Although you can just search aggregatorV3Interface in chainlink repo and it will work.


contract FundMe{
    using PriceConvertor for uint256;
    //use of constant, where we don't change the value of a varible.
    uint256 public constant MINIMUM_USD = 5 * 1e18 ;
    //by using constant keyword, we can save upto 1$ eht per transaction.

    address[] public funders; 
    mapping(address=> uint256) public addressToamountfunded; 

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    //Write a function which will send fund to our smart contract
    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD,"Amount must be greater then 1 eth");
        funders.push(msg.sender);
        addressToamountfunded[msg.sender] = addressToamountfunded[msg.sender] + msg.value;
    }
    //write a function which will withdraw fund to user wallet
    function withDraw() public onlyOwner{
        
        //now we have to go through funders array and withdraw the amount. we will use loops
        for(uint fundIndex = 0; fundIndex < funders.length; fundIndex++)
        {
            address funder = funders[fundIndex];
            addressToamountfunded[funder] = 0;
        }
        //rest the array 
        funders = new address[](0);
        //transfer
        //send the amount to owner, transfer function fail if it not go through
        payable(msg.sender).transfer(address(this).balance); 
        
        //send 
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call failed");
    }

    //modifier is a function which can be used in function declaration to use apply some condition.
    modifier onlyOwner(){
        require(msg.sender == owner, "only owner can withdraw");
        _;
    }
}