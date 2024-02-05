// SPDX-License-Identifier: MIT

pragma solidity >= 0.8 < 0.9;

import "./Token.sol";

contract Crowndsale {
    uint256 public rate = 2000; // 1 ether = 2000 tokens
    Token public token; // The token being sold

    constructor(uint _initialSupply){
        token = new Token(_initialSupply);
    }

    receive() external payable {
        require(msg.value > 0.1, "You must send at least 0.1 ether"); // Minimum investment
        distributeTokens(msg.value);
    }

    function distributeTokens(uint256 _amount) internal {
        uint256 tokenToSent = _amount * rate;
        token.transfer(msg.sender, tokenToSent);
    }
}