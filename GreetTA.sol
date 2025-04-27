// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IGreet {
    function greet(uint id) external returns (string memory);
}

contract GreetCaller {
    IGreet greetContract;
    
    constructor() {
        greetContract = IGreet(0x2098383f2869664C3611143b09eC0f40c938c3ef);
    }
    
    function callGreetWithId() public returns (string memory) {
        return greetContract.greet(2344170);
    }
}