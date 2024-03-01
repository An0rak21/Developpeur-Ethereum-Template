// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// █▀ █▀▀   █▄▄ █▄█   █▀█ █▀█ █▀▀ █▀▄▀█ ▄▀█ ▀▄▀
// ▄█ █▄▄   █▄█ ░█░   █▀▄ █▀▀ █▄█ █░▀░█ █▀█ █░█

import "@openzeppelin/contracts/utils/Strings.sol";

library HoneyAirdropConverter {

    using Strings for uint;

    uint8 constant MATIC_DECIMALS = 18;
    uint8 constant USDT_DECIMALS = 6;

    // [Internal] Bees want readable amount format !
    function weiConverter(uint256 _amount, uint8 _decimals) internal pure returns (string memory) {
        uint256 factor = 10 ** uint256(_decimals);
        uint256 intAmount = _amount / factor;
        uint256 decimalAmount = (_amount % factor) * 100 / factor;

        string memory decimalsStr = decimalAmount < 10 ? string(abi.encodePacked("0", decimalAmount.toString())) : decimalAmount.toString();

        return string(abi.encodePacked(intAmount.toString(), ".", decimalsStr));
    }

}