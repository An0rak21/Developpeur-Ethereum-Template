// SPDX-License-Identifier: MIT

pragma solidity >= 0.8 < 0.9;

contract Whitelist {
    event Authorized (address _address); // Déclaration de l'event
    event ethReceived (address _addr, uint _value);

    constructor() {
        whitelist[msg.sender] = true;
    }
    



    modifier check(){
        require(
            whitelist[msg.sender] == true,
            "You are not authorized!"
        );
        _;
    }

    mapping (address => bool) whitelist;

    function authorize (address _address) public check {
        whitelist[_address] = true;
        emit Authorized(_address);
    }
}