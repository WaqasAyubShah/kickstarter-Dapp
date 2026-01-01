// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract FallBackEg{
    uint256 public results;

    receive() external payable {
        results = 1;
    }
    fallback() external payable {
        results = 2;
    }
}