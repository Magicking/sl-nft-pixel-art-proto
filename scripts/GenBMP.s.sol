// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script, console2 } from "forge-std/Script.sol";
import { BMPImage } from "../src/BMP.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract FooScript is Script {
    using console2 for string;
    using console2 for bytes;
    using console2 for bytes;
    using BMPImage for BMPImage.Image;
    function run() public {
        vm.startBroadcast();
        BMPImage.Image memory img = BMPImage.newImage(4, 4);
        // Write a blue, white and red line pixel by pixel
        for (uint32 i = 0; i < 3; i++) {
            img = img.setPixelAt(2, i, 0, 0, 255, 255);
        }
        for (uint32 i = 0; i < 3; i++) {
            img = img.setPixelAt(1, i, 255, 255, 255, 255);
        }
        for (uint32 i = 0; i < 3; i++) {
            img = img.setPixelAt(0, i, 255, 0, 0, 255);
        }
        bytes memory out = BMPImage.encode(img);
        vm.writeFileBinary("out.bmp", out);
        vm.stopBroadcast();
    }
}