// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{

    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    uint256 private s_tokenCounter;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    error MoodNFT__CantFlipMoodIfNotOwner();

    constructor(string memory sadSVG, string memory happySvg) ERC721("Mood NFT", "MN"){
        s_happySvgImageUri = happySvg;
        s_sadSvgImageUri = sadSVG;
        s_tokenCounter = 0;
    }

    function mint() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                bytes(
                    abi.encodePacked(
                    '{"name: "',
                    name(),
                    '", description: "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": ',
                    imageURI,
                    '"}'
                    )
                )
                )
            )
        );
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public view {
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
            revert MoodNFT__CantFlipMoodIfNotOwner();
        }
        
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            s_tokenIdToMood[tokenId] == Mood.SAD;
        } else{
            s_tokenIdToMood[tokenId] == Mood.HAPPY;
        }
    }
}