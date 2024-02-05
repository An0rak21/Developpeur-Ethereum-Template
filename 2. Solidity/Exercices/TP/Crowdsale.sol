// SPDX-License-Identifier: MIT

pragma solidity >= 0.8 < 0.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Crowdsale is ERC20 {
    constructor() ERC20("An0raKToken", "ANO"){
        
    }

}