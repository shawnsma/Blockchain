// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface HelloCall {
    function greeter(string memory _greeting) external;
    function greet() external view returns (string memory);
}

contract HelloWorldRespose {
    
    HelloCall helloworld;

    constructor(address _helloaddy) {
        helloworld = HelloCall(_helloaddy);
    }
    
    function callGreeter(string memory _greeting) public {
        helloworld.greeter(_greeting);
    }
    
    function callGreet() public view returns (string memory) {
        return helloworld.greet();
    }
}