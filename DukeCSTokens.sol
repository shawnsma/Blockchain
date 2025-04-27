// SPDX-License-Identifier: Unlicense

pragma solidity >=0.7.0 <0.9.0;

interface IDukeCompsciToken {
    function transfer(address receiver, uint amount) external returns (bool);
    function transferFrom(address from, address to, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract AMMPool {
    IDukeCompsciToken public tokenX;
    IDukeCompsciToken public tokenY;
    uint256 public deadline;
    mapping(address => uint256) public lastSwapTimestamp;
    uint256 public constant MIN_DELAY = 2;
    
    constructor(address _tokenX, address _tokenY) {
        tokenX = IDukeCompsciToken(_tokenX);
        tokenY = IDukeCompsciToken(_tokenY);
    }
    
    function swapXY(uint amountX, uint minAmountOut, uint _deadline) public payable {
        require(block.timestamp <= _deadline, "Transaction expired");
        require(block.number >= lastSwapTimestamp[msg.sender] + MIN_DELAY, "Must wait between swaps");
        
        // Check balances and allowances
        require(tokenX.balanceOf(msg.sender) >= amountX, "Insufficient TokenX balance");
        require(tokenX.allowance(msg.sender, address(this)) >= amountX, "Insufficient allowance");
        
        // Calculate output amount
        uint xReserve = tokenX.balanceOf(address(this));
        uint yReserve = tokenY.balanceOf(address(this));
        uint amountY = yReserve - ((xReserve * yReserve) / (xReserve + amountX));
        require(amountY >= minAmountOut, "Slippage too high");
        require(tokenY.balanceOf(address(this)) >= amountY, "Insufficient pool TokenY balance");
        
        // Update timestamp before transfer
        lastSwapTimestamp[msg.sender] = block.number;
        
        // Execute transfers
        require(tokenX.transferFrom(msg.sender, address(this), amountX), "TokenX transfer failed");
        require(tokenY.transfer(msg.sender, amountY), "TokenY transfer failed");
    }
}