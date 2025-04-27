// SPDX-License-Identifier: Unlicense

pragma solidity >=0.7.0 <0.9.0;

contract DukeCompsciToken {
    uint256 _totalSupply = 0;
    string _symbol;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory symbol, uint256 initialSupply) {
        _symbol = symbol;
        _totalSupply = initialSupply;
        balances[msg.sender] = _totalSupply;
    }

    function transfer(address receiver, uint amount) public returns (bool) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[receiver] = balances[receiver] + amount;
        return true;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        return true;
    }

    function undo_approve() public returns (bool) {
        require(_allowances[msg.sender][msg.sender] >= 1, "No active approval");
        _allowances[msg.sender][msg.sender] = 0;
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(_allowances[from][msg.sender] >= amount, "Insufficient allowance");
        require(balances[from] >= amount, "Insufficient balance");
        
        _allowances[from][msg.sender] -= amount;
        balances[from] -= amount;
        balances[to] += amount;
        
        return true;
    }
}