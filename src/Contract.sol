// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

library CRC32 {
  function crc32LenAt(bytes memory self, uint256 offset, uint256 length) public pure returns (uint32) {
    uint32[256] memory table = [0x0, 0x77073096, 0xee0e612c, 0x990951ba, 0x76dc419, 0x706af48f, 0xe963a535, 0x9e6495a3, 0xedb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988, 0x9b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91, 0x1db71064, 0x6ab020f2, 0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7, 0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9, 0xfa0f3d63, 0x8d080df5, 0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172, 0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b, 0x35b5a8fa, 0x42b2986c, 0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59, 0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423, 0xcfba9599, 0xb8bda50f, 0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924, 0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d, 0x76dc4190, 0x1db7106, 0x98d220bc, 0xefd5102a, 0x71b18589, 0x6b6b51f, 0x9fbfe4a5, 0xe8b8d433, 0x7807c9a2, 0xf00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x86d3d2d, 0x91646c97, 0xe6635c01, 0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e, 0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457, 0x65b0d9c6, 0x12b7e950, 0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65, 0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7, 0xa4d1c46d, 0xd3d6f4fb, 0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0, 0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9, 0x5005713c, 0x270241aa, 0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f, 0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81, 0xb7bd5c3b, 0xc0ba6cad, 0xedb88320, 0x9abfb3b6, 0x3b6e20c, 0x74b1d29a, 0xead54739, 0x9dd277af, 0x4db2615, 0x73dc1683, 0xe3630b12, 0x94643b84, 0xd6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0xa00ae27, 0x7d079eb1, 0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb, 0x196c3671, 0x6e6b06e7, 0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc, 0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5, 0xd6d6a3e8, 0xa1d1937e, 0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b, 0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55, 0x316e8eef, 0x4669be79, 0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236, 0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f, 0xc5ba3bbe, 0xb2bd0b28, 0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d, 0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x26d930a, 0x9c0906a9, 0xeb0e363f, 0x72076785, 0x5005713, 0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0xcb61b38, 0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0xbdbdf21, 0x86d3d2d4, 0xf1d4e242, 0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777, 0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69, 0x616bffd3, 0x166ccf45, 0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2, 0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db, 0xaed16a4a, 0xd9d65adc, 0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9, 0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693, 0x54de5729, 0x23d967bf, 0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94, 0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d];
    uint32 crc = 0xffffffff;
    for (uint256 i = offset; i < offset+length; i++) {
      crc = table[(crc ^ uint8(self[i])) & 0xff] ^ (crc >> 8);
    }
    return crc ^ 0xffffffff;
  }
  function crc32(bytes memory self) public pure returns (uint32) {
    return crc32LenAt(self, 0, self.length);
  }
}

library PNGImage {
    using CRC32 for bytes;
    struct PNG {
      IHDR header;
      bytes data;
    }
    struct IHDR {
        uint256 width;
        uint256 height;
        uint256 bitDepth; // values 1, 2, 4, 8, or 16
        uint256 colorType; // values 0, 2, 3, 4, or 6
        uint256 compressionMethod; // value 0
        uint256 filterMethod; // value 0
        uint256 interlaceMethod; // values 0 "no interlace" or 1 "Adam7 interlace"
    }
    function getIHDRSegment(bytes memory self) public pure returns (IHDR memory segment) {
        require(self[0] == 0x89 && self[1] == 0x50 && self[2] == 0x4E && self[3] == 0x47 && self[4] == 0x0D && self[5] == 0x0A && self[6] == 0x1A && self[7] == 0x0A, "Invalid PNG header");
        require(self[12] == 0x49 && self[13] == 0x48 && self[14] == 0x44 && self[15] == 0x52, "Invalid IHDR chunk");
        segment.width = uint256(uint32(uint8(self[16])) << 24 | uint32(uint8(self[17])) << 16 | uint32(uint8(self[18])) << 8 | uint32(uint8(self[19])));
        segment.height = uint256(uint32(uint8(self[20])) << 24 | uint32(uint8(self[21])) << 16 | uint32(uint8(self[22])) << 8 | uint32(uint8(self[23])));
        segment.bitDepth = uint256(uint8(self[24]));
        segment.colorType = uint256(uint8(self[25]));
        segment.compressionMethod = uint256(uint8(self[26]));
        segment.filterMethod = uint256(uint8(self[27]));
        segment.interlaceMethod = uint256(uint8(self[28]));
    }

    function encodeIHDRSegment(IHDR memory self) public pure returns (bytes memory ihdr) {
        uint32 chunkType = 0x49484452;
        uint32 width = uint32(self.width);
        uint32 height = uint32(self.height);
        uint8 bitDepth = uint8(self.bitDepth);
        uint8 colorType = uint8(self.colorType);
        uint8 compressionMethod = uint8(self.compressionMethod);
        uint8 filterMethod = uint8(self.filterMethod);
        uint8 interlaceMethod = uint8(self.interlaceMethod);

        bytes memory buf = abi.encodePacked(chunkType, width, height, bitDepth, colorType, compressionMethod, filterMethod, interlaceMethod);
        uint32 len = uint32(buf.length - 4/* sizeof(chunkType) */);
        uint32 crc32 = buf.crc32();
        return abi.encodePacked(len, buf, crc32);
    }
    
    function encodeIDATSegment(PNG memory self) pure returns (bytes memory idat) {
        uint32 chunkType = 0x49444154;
        bytes memory buf = abi.encodePacked(chunkType, self.data);
        uint32 len = uint32(buf.length - 4/* sizeof(chunkType) */);
        uint32 crc32 = buf.crc32();
        return abi.encodePacked(len, buf, crc32);
    }

    function toB64PNG(PNG memory self) public pure returns (string memory) {
        bytes memory pngSig = hex"89504e470d0a1a0a"; // PNG header

        pngImage = abi.encodePacked(pngSig, self.ihdrb.encodeIHDRSegment(), self.encodeIDATSegment(), hex"0000000049454E44AE426082" /* IEND */);
        return string(abi.encodePacked("data:image/png;base64,", Base64.encode(pngImage)));
    }
}
contract Contract is ERC721("sl-nft-pixel-art-proto", "slnpap") {
    using PNGImage for bytes;
    using PNGImage for PNGImage.IHDR;
    using Strings for uint256;
       constructor() {
        _mint(msg.sender, 0);
    }

    function constructTokenURI() public pure returns (string memory) {
        //string memory img = "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAJI0lEQVRIDQEYCef2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVAAAAfQAAANAAAADxAAAA9AAAALsAAAA2AAAAAAAAAAAAAAAA////YP//////////////MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApAAAA5AAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/gAAAFcAAAAAAAAAAP///47/////////+////wYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1QAAAP8AAADqAAAAUAAAAA8AAAAuAAAA2AAAAP8AAADiAAAAAAAAAAD///+8/////////9MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEwAAAP8AAAD/AAAAcQAAAAAAAAAAAAAAAAAAAGMAAADoAAAA6AAAABIAAAAA////6f////////+lAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkAAAD4AAAA/wAAAKoAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////GP//////////////dgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAegAAAP8AAAD/AAAA4AAAAIIAAAAeAAAAAAAAAAAAAAAAAAAAAP///0b//////////////0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAABtAAAA8QAAAP8AAAD/AAAA/AAAAIoAAAAFAAAAAAAAAAD///90//////////////8ZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAABgAAAAxAAAAP8AAAD/AAAAjwAAAAAAAAAA////o//////////rAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8AAAAkAAAAJAAAAAEAAAAAAAAAAAAAAAAAAACaAAAA/wAAAP0AAAASAAAAAP///9H/////////vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAABVAAAA2wAAANsAAAAjAAAAAAAAAAAAAAAAAAAAzwAAAAAAAAACAAAAD////wUAAAAoAAAAAAAAANIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJwAAAP4AAAD/AAAAtAAAACMAAAANAAAASQAAAOQAAAD/AAAA3wAAAAD///8t//////////////9r////EP///xD///8Q////EP///xD///8GAAAAAAAAAAAAAAAAAAAAAAAAAACEAAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA9AAAAEEAAAAA////W///////////////////////////////////////////////VQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEUAAADBAAAA8wAAAPkAAADdAAAAlwAAACQAAAAAAAAAAP///4n//////////////////////////////////////////////ycAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAikcmi7oKg+QAAAAASUVORK5CYII=";
        bytes memory pngSig = hex"89504e470d0a1a0a";
        bytes
            memory IHDR = abi.encodePacked(
                hex"0000000d", // Chunk length
                hex"49484452", // Chunk Type: IHDR
                hex"00000018000000180806000000", // data (chunk length)
                hex"e0773df8"); // CRC
        /*
        Extract: width(4 bytes), height(4 bytes), bit depth(1 byte),
color type(1 byte), compression method(1 byte), filter method (1 byte) from IHDR header */
        bytes memory data = hex"0000092349444154480d011809e7f60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000150000007d000000d0000000f1000000f4000000bb00000036000000000000000000000000ffffff60ffffffffffffffffffffff300000000000000000000000000000000000000000000000000000000000000000000000000000000029000000e4000000ff000000ff000000ff000000ff000000ff000000fe000000570000000000000000ffffff8efffffffffffffffbffffff0600000000000000000000000000000000000000000000000000000000000000000000000000000000d5000000ff000000ea000000500000000f0000002e000000d8000000ff000000e20000000000000000ffffffbcffffffffffffffd30000000000000000000000000000000000000000000000000000000000000000000000000000000013000000ff000000ff0000007100000000000000000000000000000063000000e8000000e80000001200000000ffffffe9ffffffffffffffa50000000000000000000000000000000000000000000000000000000000000000000000000000000009000000f8000000ff000000aa00000003000000000000000000000000000000000000000000000000ffffff18ffffffffffffffffffffff7600000000000000000000000000000000000000000000000000000000000000000000000000000000000000007a000000ff000000ff000000e0000000820000001e00000000000000000000000000000000ffffff46ffffffffffffffffffffff480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000006d000000f1000000ff000000ff000000fc0000008a000000050000000000000000ffffff74ffffffffffffffffffffff19000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00000060000000c4000000ff000000ff0000008f0000000000000000ffffffa3ffffffffffffffeb000000000000000000000000000000000000000000000000000000000000000000000000000000000f0000002400000024000000010000000000000000000000000000009a000000ff000000fd0000001200000000ffffffd1ffffffffffffffbc0000000000000000000000000000000000000000000000000000000000000000020000000000000055000000db000000db00000023000000000000000000000000000000cf00000000000000020000000fffffff050000002800000000000000d20000000000000000000000000000000000000000000000000000000000000000000000000000000027000000fe000000ff000000b4000000230000000d00000049000000e4000000ff000000df00000000ffffff2dffffffffffffffffffffff6bffffff10ffffff10ffffff10ffffff10ffffff10ffffff06000000000000000000000000000000000000000084000000ff000000ff000000ff000000ff000000ff000000ff000000f40000004100000000ffffff5bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5500000000000000000000000000000000000000000000000045000000c1000000f3000000f9000000dd00000097000000240000000000000000ffffff89ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008a47268bba0a83e40000000049454e44ae426082";
//        bytes
//            memory data = hex"0000000d4948445200000018000000180806000000e0773df80000092349444154480d011809e7f60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000150000007d000000d0000000f1000000f4000000bb00000036000000000000000000000000ffffff60ffffffffffffffffffffff300000000000000000000000000000000000000000000000000000000000000000000000000000000029000000e4000000ff000000ff000000ff000000ff000000ff000000fe000000570000000000000000ffffff8efffffffffffffffbffffff0600000000000000000000000000000000000000000000000000000000000000000000000000000000d5000000ff000000ea000000500000000f0000002e000000d8000000ff000000e20000000000000000ffffffbcffffffffffffffd30000000000000000000000000000000000000000000000000000000000000000000000000000000013000000ff000000ff0000007100000000000000000000000000000063000000e8000000e80000001200000000ffffffe9ffffffffffffffa50000000000000000000000000000000000000000000000000000000000000000000000000000000009000000f8000000ff000000aa00000003000000000000000000000000000000000000000000000000ffffff18ffffffffffffffffffffff7600000000000000000000000000000000000000000000000000000000000000000000000000000000000000007a000000ff000000ff000000e0000000820000001e00000000000000000000000000000000ffffff46ffffffffffffffffffffff480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000006d000000f1000000ff000000ff000000fc0000008a000000050000000000000000ffffff74ffffffffffffffffffffff19000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00000060000000c4000000ff000000ff0000008f0000000000000000ffffffa3ffffffffffffffeb000000000000000000000000000000000000000000000000000000000000000000000000000000000f0000002400000024000000010000000000000000000000000000009a000000ff000000fd0000001200000000ffffffd1ffffffffffffffbc0000000000000000000000000000000000000000000000000000000000000000020000000000000055000000db000000db00000023000000000000000000000000000000cf00000000000000020000000fffffff050000002800000000000000d20000000000000000000000000000000000000000000000000000000000000000000000000000000027000000fe000000ff000000b4000000230000000d00000049000000e4000000ff000000df00000000ffffff2dffffffffffffffffffffff6bffffff10ffffff10ffffff10ffffff10ffffff10ffffff06000000000000000000000000000000000000000084000000ff000000ff000000ff000000ff000000ff000000ff000000f40000004100000000ffffff5bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5500000000000000000000000000000000000000000000000045000000c1000000f3000000f9000000dd00000097000000240000000000000000ffffff89ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008a47268bba0a83e40000000049454e44ae426082";
        bytes memory pngImage = abi.encodePacked(pngSig, IHDR, data);
        PNGImage.IHDR memory ihdr = pngImage.getIHDRSegment();
        ihdr.height = 24;
        ihdr.width = 24;
        bytes memory ihdrbuf = ihdr.encodeIHDRSegment();
        pngImage = abi.encodePacked(pngSig, ihdrbuf, data);
        string memory height = ihdr.height.toString();
        string memory width = ihdr.width.toString();
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "Norem Ipsum",
                                '", "description":"',
                                "height ", height, "width ", width,
                                '", "image":"',
                                "data:image/png;base64,",
                                Base64.encode(pngImage),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function tokenURI(uint256 tokenId)
        public
        pure
        override
        returns (string memory)
    {
        // Return a json structure with the metadata embedding the image/png bellow as a data uri in the imageURL scheme
        tokenId;
        return constructTokenURI();
    }
   */
}
