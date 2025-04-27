// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract Hello {
    string greeting;
    
    function greeter(string memory _greeting) public {
        greeting = _greeting;
    }
    
    function greet() public view returns (string memory) {
        return greeting;
    }
}