// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 ;

contract SafeMath{
uint8 public Bignumber = 255; //checked

    function add() public {
        Bignumber = Bignumber + 1;
    }
    //after solidity 0.8 we have SafeMath but with checked and unchecked...
    //why we will use unchecked, because it is gas efficient  if you are sure that we will not cross 255 then we can
    //use it.. 
}