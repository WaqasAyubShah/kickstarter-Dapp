// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConvertor{
    
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