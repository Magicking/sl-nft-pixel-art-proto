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
        header[0] = 0x40;
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
    function newImage(uint32 width, uint32 height) pure public returns (Image memory) {
        Image memory image;
        image.header.signature = 0x4d42;
        image.header.fileSize = 40 + 14 + width * height * 4;
        image.header.reserved = 0;
        image.header.dataOffset = 40 + 14;
        image.infoHeader.width = width;
        image.infoHeader.height = height;
        image.infoHeader.colorPlanes = 1;
        image.infoHeader.bitsPerPixel = 24; // TODO
        image.infoHeader.compression = 0;
        image.infoHeader.imageSize = width * height * 4;
        image.infoHeader.horizontalResolution = 0xC40E0000; // TODO
        image.infoHeader.verticalResolution = 0xC40E0000; // TODO
        image.infoHeader.colorsInPalette = 0;
        image.infoHeader.importantColors = 5; // TODO
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
    function setPixelAt(Image memory image, uint32 x, uint32 y, uint8 r, uint8 g, uint8 b, uint8 a) pure public {
        uint32 width = image.infoHeader.width;
        uint32 height = image.infoHeader.height;
        require(x < width, "x out of bounds");
        require(y < height, "y out of bounds");
        uint32 index = (height - y - 1) * width * 4 + x * 4;
        image.data[index] = bytes1(r);
        image.data[index + 1] = bytes1(g);
        image.data[index + 2] = bytes1(b);
        image.data[index + 3] = bytes1(a);
    }
/*
    function getPixelAt(Image memory image, uint32 x, uint32 y) pure public (bytes1 r, bytes1 g, bytes1 b, bytes1 a){
        uint32 width = image.infoHeader.width;
        uint32 index = image.infoHeader.width
        r = 
    }*/
    function encode(Image memory img) pure public returns (bytes memory file) {
        bytes memory header = writeHeader(img.header);
        bytes memory infoHeader = writeInfoHeader(img.infoHeader);
        bytes memory data = img.data;
        
        file = new bytes(header.length + infoHeader.length + data.length);
        for (uint256 i = 0; i < header.length; i++) {
            file[i] = header[i];
        }
        for (uint256 i = 0; i < infoHeader.length; i++) {
            file[header.length + i] = infoHeader[i];
        }
        for (uint256 i = 0; i < data.length; i++) {
            file[header.length + infoHeader.length + i] = data[i];
        }
        return file;
    }
    function toB64BMP(
        bytes memory canvas
    ) public pure returns (string memory) {
        bytes memory fileHeader = abi.encodePacked(
            hex"42_4d", // BM
            hex"36_09_00_00", // size of the bitmap file in bytes (14 (file header) + 40 (info header) + size of raw data (1024))
            hex"00_00_00_00", // 2x2 bytes reserved
            hex"36_00_00_00" // offset of pixels in bytes
        );
        // TODO info header as a structurized data
        bytes memory infoHeader = abi.encodePacked(
            hex"28_00_00_00", // size of the header in bytes (40)
            hex"18_00_00_00", // width in pixels 24
            hex"18_00_00_00", // height in pixels 24
            hex"01_00", // number of color plans (must be 1)
            hex"20_00", // number of bits per pixel (24)
            hex"00_00_00_00", // type of compression (none)
            hex"00_09_00_00", // size of the raw bitmap data (1024)
            hex"C4_0E_00_00", // horizontal resolution
            hex"C4_0E_00_00", // vertical resolution
            hex"00_00_00_00", // number of used colours
            hex"05_00_00_00" // number of important colours
        );
        bytes memory headers = abi.encodePacked(fileHeader, infoHeader);

        return
            string(
                abi.encodePacked(
                    "data:image/bmp;base64,",
                    Base64.encode(abi.encodePacked(headers, canvas))
                )
            );
    }
}