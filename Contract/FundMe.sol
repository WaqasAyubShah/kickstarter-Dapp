// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

error Unauthorized();

//Also we can import the AggregartorV3Interface from chainlink repo
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//import {PriceConvertor} from "./PriceConvertor.sol";
library PriceConvertor{
    
    //Check price feed on chainlink for this
    function getPrice() public view returns (uint256) {
        //price feed contract hash: https://docs.chain.link/data-feeds/price-feeds/addresses?networkType=testnet&testnetPage=2 
        //Address for sapoliea 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //Address for zkSync: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        // we can work around abi by using interfaces.
        //ABI 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);

        (
            /* uint80 roundID */,
            int256 answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
       // (,int256 price,,,) = priceFeed.latestRoundData;
        //price of ETH in usdt
        //2000,00,000,000 covert it to 18 dec...
        return uint256(answer * 1e10);
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmouninUSD = (ethAmount * ethPrice)/1e18;
        return ethAmouninUSD;
    }

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }
}
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

    //use of immutable
    //Gas saved: 
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
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
        //require(msg.sender == i_owner, "only owner can withdraw");
        if(msg.sender != i_owner)
           revert Unauthorized();
        _; //order of _; matters 
    }

    //receive & fallback 
    receive() external payable {
        fund();
    }
    fallback() external payable { 
        fund();
    }
}