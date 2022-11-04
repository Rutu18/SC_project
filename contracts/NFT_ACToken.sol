// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT_CapAC
 * This provides a public safeMint, mint, and burn functions for testing purposes
 */
contract NFT_CapAC is ERC721, ERC721Enumerable, Ownable {
    /*
        Define struct to represent capability token data.
    */
    struct AccessControlToken {
        string name;
        string gender;
        // uint256 issueDate;
        
        // keep aligned, used to easily return a string array for query
        string[] authInstitutionNames;
        address[] authInstitutions;
        
        uint8 institutionAmount;
        //mapping(address => string) authorizedInstitutions;
            
    }
    
    // Mapping from token ID to CapAC
    mapping(uint256 => CapAC) private _capAC;

    // event handle function
    event OnCapAC_Update(uint256 tokenId, uint _value);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);

        // mint a CapAC given tokenId
        _mintCapAC(tokenId);
    }

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
        // mint a CapAC given tokenId
        _burnCapAC(tokenId);
    }

    function query_CapAC(uint256 tokenId) public view returns (uint, 
                                                        uint256, 
                                                        uint256, 
                                                        string memory) {
        // return(id, issuedate, expireddate, authorization);  
        return(_capAC[tokenId].id, 
            _capAC[tokenId].issuedate,
            _capAC[tokenId].expireddate,
            _capAC[tokenId].authorization
            );      
    }

    function _mintCapAC(string memory tokenId,
                        string memory institutionName,
                        string memory institutionAddr,
                        string memory patientName,
                        string memory patientGender) public returns (bool)
    }

    function _burnCapAC(uint256 tokenId) private {
        delete _capAC[tokenId];
    }

    // Set time limitation for a CapAC
    function setCapAC_expireddate(uint256 tokenId, 
                                    uint256 issueddate, 
                                    uint256 expireddate) public {
        require(ownerOf(tokenId) == msg.sender, "NFT_CapAC: setCapAC_expireddate from incorrect owner");

        _capAC[tokenId].id += 1;
        _capAC[tokenId].issuedate = issueddate;
        _capAC[tokenId].expireddate = expireddate;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);

    }

    // Assign access rights to a CapAC
    function setCapAC_authorization(uint256 tokenId, 
                                        string memory accessright) public {
        require(ownerOf(tokenId) == msg.sender, "NFT_CapAC: setCapAC_authorization from incorrect owner");

        _capAC[tokenId].id += 1;
        _capAC[tokenId].authorization = accessright;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);
   
    }
}
