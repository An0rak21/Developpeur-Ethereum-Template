// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

contract auction {
    address highestBidder;
    uint highestBid;

    mapping (address => uint) pendingReturns;

    function bid() payable public {
        require(msg.value >= highestBid);


        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

       highestBidder = msg.sender;
       highestBid = msg.value;
    }
}
