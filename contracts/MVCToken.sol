// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract MVCToken is ERC20 {
    constructor (string memory name_, string memory symbol_) ERC20(name_,symbol_) public {
    }
}