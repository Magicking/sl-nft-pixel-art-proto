// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "solidity-bytes-utils/BytesLib.sol";

library BMPImage {
    /* 
    TODO functions:
    - getPixelAt
    - setPixelAt
    - write headers
    - encode function
    - pretty print headers
     */
    struct InfoHeader {
        uint32 width; // width in pixels
        uint32 height; // height in pixels
        uint16 colorPlanes; // number of color planes (must be 1)
        uint16 bitsPerPixel; // bits per pixel
        uint32 compression; // compression method
        uint32 imageSize; // image size in bytes
        uint32 horizontalResolution; // horizontal resolution in pixels per meter
        uint32 verticalResolution; // vertical resolution in pixels per meter
        uint32 colorsInPalette; // number of colors in the color palette
        uint32 importantColors; // number of important colors used
    }

    struct Image {
        Header header;
        InfoHeader infoHeader;
        bytes data;
    }
    function writeInfoHeader(InfoHeader memory h)pure public  returns (bytes memory) {
        bytes memory header = new bytes(40);
        // write header size
        header[0] = 0x28;
        header[1] = 0;
        header[2] = 0;
        header[3] = 0;
        // write image width
        header[4] = bytes1(uint8(h.width));
        header[5] = bytes1(uint8(h.width >> 8));
        header[6] = bytes1(uint8(h.width >> 16));
        header[7] = bytes1(uint8(h.width >> 24));
        // write image height
        header[8] = bytes1(uint8(h.height));
        header[9] = bytes1(uint8(h.height >> 8));
        header[10] = bytes1(uint8(h.height >> 16));
        header[11] = bytes1(uint8(h.height >> 24));
        // write color planes
        header[12] = bytes1(uint8(h.colorPlanes));
        header[13] = bytes1(uint8(h.colorPlanes >> 8));
        // write bits per pixel
        header[14] = bytes1(uint8(h.bitsPerPixel));
        header[15] = bytes1(uint8(h.bitsPerPixel >> 8));
        // write compression method
        header[16] = bytes1(uint8(h.compression));
        header[17] = bytes1(uint8(h.compression >> 8));
        header[18] = bytes1(uint8(h.compression >> 16));
        header[19] = bytes1(uint8(h.compression >> 24));
        // write image size
        uint32 imageSize = h.imageSize;
        header[20] = bytes1(uint8(imageSize));
        header[21] = bytes1(uint8(imageSize >> 8));
        header[22] = bytes1(uint8(imageSize >> 16));
        header[23] = bytes1(uint8(imageSize >> 24));
        // write horizontal resolution
        header[24] = bytes1(uint8(h.horizontalResolution));
        header[25] = bytes1(uint8(h.horizontalResolution >> 8));
        header[26] = bytes1(uint8(h.horizontalResolution >> 16));
        header[27] = bytes1(uint8(h.horizontalResolution >> 24));
        // write vertical resolution
        header[28] = bytes1(uint8(h.verticalResolution));
        header[29] = bytes1(uint8(h.verticalResolution >> 8));
        header[30] = bytes1(uint8(h.verticalResolution >> 16));
        header[31] = bytes1(uint8(h.verticalResolution >> 24));
        // write colors in palette
        header[32] = bytes1(uint8(h.colorsInPalette));
        header[33] = bytes1(uint8(h.colorsInPalette >> 8));
        header[34] = bytes1(uint8(h.colorsInPalette >> 16));
        header[35] = bytes1(uint8(h.colorsInPalette >> 24));
        // write important colors
        header[36] = bytes1(uint8(h.importantColors));
        header[37] = bytes1(uint8(h.importantColors >> 8));
        header[38] = bytes1(uint8(h.importantColors >> 16));
        header[39] = bytes1(uint8(h.importantColors >> 24));

        return header;
    }
    struct Header {
        uint16 signature; // signature (must be 0x4d42)
        uint32 fileSize; // file size in bytes
        uint32 reserved; // reserved (must be 0)
        uint32 dataOffset; // offset to image data in bytes from beginning of file (54 bytes)
    }
    function writeHeader(Header memory h) pure public  returns (bytes memory) {
        bytes memory header = new bytes(14);
        // write signature
        header[0] = bytes1(uint8(h.signature));
        header[1] = bytes1(uint8(h.signature >> 8));
        // write file size
        uint32 fileSize = h.fileSize;
        header[2] = bytes1(uint8(fileSize));
        header[3] = bytes1(uint8(fileSize >> 8));
        header[4] = bytes1(uint8(fileSize >> 16));
        header[5] = bytes1(uint8(fileSize >> 24));
        // write reserved
        header[6] = bytes1(uint8(h.reserved));
        header[7] = bytes1(uint8(h.reserved >> 8));
        header[8] = bytes1(uint8(h.reserved >> 16));
        header[9] = bytes1(uint8(h.reserved >> 24));
        // write data offset
        header[10] = bytes1(uint8(h.dataOffset));
        header[11] = bytes1(uint8(h.dataOffset >> 8));
        header[12] = bytes1(uint8(h.dataOffset >> 16));
        header[13] = bytes1(uint8(h.dataOffset >> 24));

        return header;
    }
    function switchEndianness32(uint32 i) pure internal returns (uint32 out) {
        return ((i >> 24)&0x000000ff) | ((i >> 8)&0x0000ff00) | ((i << 8)&0x00ff0000) | ((i<<24)&0xff000000);
    }
    function newImage(uint32 width, uint32 height) pure public returns (Image memory) {
        Image memory image;
        image.header.signature = 0x4d42;
        image.header.fileSize = 54 + width * height * 4;
        image.header.reserved = 0;
        image.header.dataOffset = 0x28 + 14;
        image.infoHeader.width = width;
        image.infoHeader.height = height;
        image.infoHeader.colorPlanes = 1;
        image.infoHeader.bitsPerPixel = 32;
        image.infoHeader.compression = 0;
        image.infoHeader.imageSize = width * height * 4;
        image.infoHeader.horizontalResolution = 0x00000b13;
        image.infoHeader.verticalResolution = 0x00000b13;
        /* Specifies the number of color indexes in the color table
        actually used by the bitmap. If this value is zero, the bitmap uses the
        maximum number of colors corresponding to the value of the biBitCount member.
        For more information on the maximum sizes of the color table, see the
        description of the BITMAPINFO structure earlier in this topic.
        */
        image.infoHeader.colorsInPalette = 0;
        /*
        Specifies the number of color indexes that are considered
        important for displaying the bitmap. If this value is zero, all colors are
        important.
         */
        image.infoHeader.importantColors = 0;

        image.data = new bytes(width * height * 4);
        return image;
    }

    // Human pixel layout
    /****************
    * 0,0           *
    *               *
    *               *
    *       w-1;h-1 *
    ****************/

    // Canvas pixel layout
    /****************
    *       w-1;h-1 *
    *               *
    *               *
    * 0,0           *
    ****************/

    // setPixelAt convert (x,y) from human to canvas layout
    // 32 bits per pixel
    function setPixelAt(Image memory image, uint32 x, uint32 y, uint8 r, uint8 g, uint8 b, uint8 a) public returns (Image memory)  {
        uint32 width = image.infoHeader.width;
        uint32 height = image.infoHeader.height;
        require(x < width, "x out of bounds");
        require(y < height, "y out of bounds");
        uint32 index = x * 4 + ((height - y - 1) * width * 4);
        bytes memory mem = image.data;/*
        image.data[index] = bytes1(r);
        image.data[index + 1] = bytes1(g);
        image.data[index + 2] = bytes1(b);
        image.data[index + 3] = bytes1(a);*/
        assembly {
            // Pascal type array with length at the beginning
            index := add(add(mem, 0x20), index)
            mstore8(index, r)
            index := add(index, 1)
            mstore8(index, g)
            index := add(index, 1)
            mstore8(index, b)
            index := add(index, 1)
            mstore8(index, a)
        }
        return image;
    }

    function encode(Image memory img) pure public returns (bytes memory file) {
        bytes memory header = writeHeader(img.header);
        bytes memory infoHeader = writeInfoHeader(img.infoHeader);
        
        file = new bytes(header.length + infoHeader.length + img.data.length);
        for (uint256 i = 0; i < header.length; i++) {
            file[i] = header[i];
        }
        for (uint256 i = 0; i < infoHeader.length; i++) {
            file[header.length + i] = infoHeader[i];
        }
        for (uint256 i = 0; i < img.data.length; i++) {
            file[header.length + infoHeader.length + i] = img.data[i];
        }
        return file;
    }

    function encodeURI(Image memory img) pure public returns (string memory) {
        return string(abi.encodePacked("data:image/bmp;base64,", Base64.encode(encode(img))));
    }

    function copyBytes(bytes memory _bytes) public pure returns (bytes memory) {
        bytes memory copy = new bytes(_bytes.length);
        uint256 max = _bytes.length + 31;
        for (uint256 i = 32; i <= max; i += 32) {
            assembly {
                mstore(add(copy, i), mload(add(_bytes, i)))
            }
        }
        return copy;
    }
}