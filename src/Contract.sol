// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Contract is ERC721("sl-nft-pixel-art-proto", "slnpap") {

    constructor() {
        _mint(msg.sender, 0);
    }

        function constructTokenURI()
        public
        pure
        returns (string memory)
    {
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
                                "Lorem Ipsum",
                                '", "image":"',
                                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAJI0lEQVRIDQEYCef2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVAAAAfQAAANAAAADxAAAA9AAAALsAAAA2AAAAAAAAAAAAAAAA////YP//////////////MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApAAAA5AAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/gAAAFcAAAAAAAAAAP///47/////////+////wYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1QAAAP8AAADqAAAAUAAAAA8AAAAuAAAA2AAAAP8AAADiAAAAAAAAAAD///+8/////////9MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEwAAAP8AAAD/AAAAcQAAAAAAAAAAAAAAAAAAAGMAAADoAAAA6AAAABIAAAAA////6f////////+lAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkAAAD4AAAA/wAAAKoAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////GP//////////////dgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAegAAAP8AAAD/AAAA4AAAAIIAAAAeAAAAAAAAAAAAAAAAAAAAAP///0b//////////////0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAABtAAAA8QAAAP8AAAD/AAAA/AAAAIoAAAAFAAAAAAAAAAD///90//////////////8ZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAABgAAAAxAAAAP8AAAD/AAAAjwAAAAAAAAAA////o//////////rAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8AAAAkAAAAJAAAAAEAAAAAAAAAAAAAAAAAAACaAAAA/wAAAP0AAAASAAAAAP///9H/////////vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAABVAAAA2wAAANsAAAAjAAAAAAAAAAAAAAAAAAAAzwAAAAAAAAACAAAAD////wUAAAAoAAAAAAAAANIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJwAAAP4AAAD/AAAAtAAAACMAAAANAAAASQAAAOQAAAD/AAAA3wAAAAD///8t//////////////9r////EP///xD///8Q////EP///xD///8GAAAAAAAAAAAAAAAAAAAAAAAAAACEAAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA9AAAAEEAAAAA////W///////////////////////////////////////////////VQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEUAAADBAAAA8wAAAPkAAADdAAAAlwAAACQAAAAAAAAAAP///4n//////////////////////////////////////////////ycAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAikcmi7oKg+QAAAAASUVORK5CYII=",
                            '"}'
                            )
                        )
                    )
                )
            );
    }
    function tokenURI(uint256 tokenId) override public pure returns (string memory) {
        // Return a json structure with the metadata embedding the image/png bellow as a data uri in the imageURL scheme
        return constructTokenURI();
    }
}
