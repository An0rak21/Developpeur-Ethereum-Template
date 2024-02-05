// SPDX-License-Identifier: MIT

pragma solidity >= 0.8 < 0.9;

contract Transfert {
    address myAddress;

    function setmyAddress (address _myaddress) external {
        myAddress = _myaddress;
    }

    function getBalance () external view returns (uint) {
        return  myAddress.balance;
        }

    function getBalanceOtherAdress (address _address) external view returns (uint) {
        return _address.balance;
    }

    function callTransfert(address payable _to) external payable {
        (bool success, )= _to.call{value: msg.value}("");
        require (success, unicode"transfer d’eth échoué");
        require (msg.value > 1 wei, unicode"Montant insuffisant");
    }

    function transfertConditional (uint _minBalance) external payable {
        if (myAddress.balance > _minBalance) {
            (bool success, )= myAddress.call{value: msg.value}("");
            require (success, unicode"transfer d’eth échoué");
            require (msg.value > 1 wei, unicode"Montant insuffisant");
        } revert (unicode"Balnce insuffisante");
    }
}