// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8 < 0.9;

contract Time {
    function getTime() public view returns (uint){
        return block.timestamp;
    }
}