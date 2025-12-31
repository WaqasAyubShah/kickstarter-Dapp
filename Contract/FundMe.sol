// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

//Also we can import the AggregartorV3Interface from chainlink repo

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//from where i got the interface, if you are cursious about it
//here is the link: https://github.com/smartcontractkit/smart-contract-examples/blob/630d83e9be2ee27625b13986c8d9938c4523397d/pricefeed-golang/aggregatorv3/AggregatorV3Interface.sol
//Although you can just search aggregatorV3Interface in chainlink repo and it will work.

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   // getRoundData and latestRoundData should both raise "No data present"
//   // if they do not have data to report, instead of returning unset values
//   // which could be misinterpreted as actual reported values.
//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }

contract FundMe{
    uint256 public minimumUsd = 5 * 1e18 ;

    //Write a function which will send fund to our smart contract
    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUsd,"Amount must be greater then 1 eth");
    }
    // //write a function which will withdraw fund to user wallet
    // function withDraw() public{
    // }

    //Check price feed on chainlink for this
    function getPrice() public view returns (uint256) {
        //price feed contract hash: https://docs.chain.link/data-feeds/price-feeds/addresses?networkType=testnet&testnetPage=2 
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // we can work around abi by using interfaces.
        //ABI 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

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
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}