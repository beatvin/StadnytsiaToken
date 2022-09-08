// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.16;

contract StadnytsiaToken {
    uint256 public totalSupply;
    mapping(address => uint256) private balances;

    mapping(address => mapping(address => uint)) public allowance;

    mapping(address => bool) private owners;

    string public name = "StadnytsiaToken";
    string public symbol = "ST";
    uint8 public decimals = 18;

    uint256 private deployTimeStamp = block.timestamp;
    uint256 private timeToBurn = deployTimeStamp + 5 minutes;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner,address indexed spender,uint256 value);

    constructor() {
        owners[msg.sender] = true;
        totalSupply = 1000 ether;
        balances[msg.sender] = totalSupply;
    }

    modifier canBeBurned() {
        require(block.timestamp >= timeToBurn, "Token cannot be burned yet!");
        _;
    }

    modifier onlyOwner() {
        require(owners[msg.sender], "This owner does not exist!");
        _;
    }

    function balanceOf(address _address) external view returns (uint256) {
        return balances[_address];
    }

    function myBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getOneToken() external returns (bool) {
        totalSupply += 1 ether;
        balances[msg.sender] += 1 ether;

        emit Transfer(address(0), msg.sender, 1 ether);

        return true;
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function burn(uint256 amount) external canBeBurned {
        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

}
