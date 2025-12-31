// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//Also we can import the AggregartorV3Interface from chainlink repo

import {PriceConvertor} from "./PriceConvertor.sol";
//from where i got the interface, if you are cursious about it
//here is the link: https://github.com/smartcontractkit/smart-contract-examples/blob/630d83e9be2ee27625b13986c8d9938c4523397d/pricefeed-golang/aggregatorv3/AggregatorV3Interface.sol
//Although you can just search aggregatorV3Interface in chainlink repo and it will work.


contract FundMe{
    using PriceConvertor for uint256;

    uint256 public minimumUsd = 5 * 1e18 ;
    address[] public funders; 
    mapping(address=> uint256) public addressToamountfunded; 

    //Write a function which will send fund to our smart contract
    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd,"Amount must be greater then 1 eth");
        funders.push(msg.sender);
        addressToamountfunded[msg.sender] = addressToamountfunded[msg.sender] + msg.value;
    }
    // //write a function which will withdraw fund to user wallet
    // function withDraw() public{
    // }
}