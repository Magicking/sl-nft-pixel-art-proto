// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {Contract} from "src/Contract.sol";

contract ContractTest is Test {
    function setUp() public {}

    function testExample() public {
        vm.startPrank(address(0xB0B));
        Contract c = new Contract();
        console2.log(c.tokenURI(0));
        assertTrue(true);
    }
}
