// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT_CapAC
 * This provides a public safeMint, mint, and burn functions for testing purposes
 */
contract NFT_ACToken is ERC721, ERC721Enumerable, Ownable {
    /*
        Define struct to represent capability token data.
    */
    //Patient
    struct AccessControlToken {
        uint id; 
        string name;
        string gender;
        // uint256 issueDate;
        string authorization;

        mapping(address=>Doctor) DoctorInfo; // Map doctor info
        mapping(address=>EMR) EMRInfo; // Map EMR info

        // define a tracker array
        DataTracker[] _dataTracker;
        
        // keep aligned, used to easily return a string array for query
        // string[] authInstitutionNames;
        // address[] authInstitutions;
        
        // uint8 institutionAmount;
        //mapping(address => string) authorizedInstitutions;
            
    }


    struct Doctor {
        string name; // Name of doctor
        string prescription;
    }

    /*
        Define struct to represent data tracker object.
    */
    struct DataTracker {
        address sender;     // from previous owner
        address receiver;   // to current owner
    }

    struct HealthRecords {
        string patientname;
        string authInstitutionNames;
        string treatment;    
   }



    // Mapping from token ID to AccessControlToken
    mapping(uint256 => AccessControlToken) private _capAC;

    

    // mapping(address=> mapping(address => HealthRecords)) HealthInfo;


    // event handle function
    event OnCapAC_Update(uint256 tokenId, uint _value);

    // event handle function
    event OnDataTracker_Update(uint256 tokenId, uint _value);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // event DrDetailsAdded(address doctor);

    // event HealthRecordsAdded(address dr, address patient);

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
                                                        string memory, 
                                                        string memory,
                                                        string memory) {
        // return(id, issuedate, expireddate, authorization);  
        return(_capAC[tokenId].id, 
            _capAC[tokenId].name,
            _capAC[tokenId].gender,
            _capAC[tokenId].authorization
            );      
    }

    function _mintCapAC(uint256 tokenId) public returns (bool){
        _capAC[tokenId].id = 1;
        _capAC[tokenId].name = "";
        _capAC[tokenId].gender = "";
        //_capAC[tokenId].authorization = 'NULL';
    }

    function _burnCapAC(uint256 tokenId) private {
        delete _capAC[tokenId];
    }

    // Set time limitation for a CapAC
    function setCapAC_gender(uint256 tokenId, 
                                    string memory name, 
                                    string memory gender) public {
        require(ownerOf(tokenId) == msg.sender, "NFT_ACToken: setCapAC_gender from incorrect owner");

        _capAC[tokenId].id += 1;
        _capAC[tokenId].name = name;
        _capAC[tokenId].gender = gender;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);

    }

    // Assign access rights to a CapAC
    function setCapAC_authorization(uint256 tokenId, 
                                        string memory accessright) public {
        require(ownerOf(tokenId) == msg.sender, "NFT_ACToken: setCapAC_authorization from incorrect owner");

        _capAC[tokenId].id += 1;
        _capAC[tokenId].authorization = accessright;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);
   
    }

    //Function to add Dr details
    function setDoctorDetails(uint256 tokenId,
                            address EMR_Id,
                            string memory _name, 
                            string memory _prescription) public {

        require(ownerOf(tokenId) == msg.sender, "NFT_ACToken: setDoctorDetails from incorrect owner");
        
        _capAC[tokenId].id += 1;
        _capAC[tokenId].DoctorInfo[doctor_Id].name=_name;
        _capAC[tokenId].DoctorInfo[doctor_Id].prescription=_prescription;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);
    }

    // Function to get Doctor details for admin
    function getDoctorDetails(uint256 tokenId, 
                                address doctor_Id) public view returns(uint,
                                                                        string memory, 
                                                                        string memory){
        // string memory _name = _capAC[tokenId].DoctorInfo[doctor_Id].name;
        // string memory _prescription = _capAC[tokenId].DoctorInfo[doctor_Id].prescription;

        return(_capAC[tokenId].id,
            _capAC[tokenId].DoctorInfo[doctor_Id].name,
                _capAC[tokenId].DoctorInfo[doctor_Id].prescription);
    }


    //Function to add EMR details
    function setEMRDetails(uint256 tokenId,
                            address doctor_Id,
                            string memory _patientname, 
                            string memory _authInstitutionNames,
                            string memory _tretment) public {

        require(ownerOf(tokenId) == msg.sender, "NFT_ACToken: setEMRDetails from incorrect owner");
        
        _capAC[tokenId].id += 1;
        _capAC[tokenId].EMRInfo[EMR_Id].patientname=_patientname;
        _capAC[tokenId].EMRInfo[EMR_Id].authInstitutionNames=_authInstitutionNames;
        _capAC[tokenId].EMRInfo[EMR_Id].treatment=_treatment;

        emit OnCapAC_Update(tokenId, _capAC[tokenId].id);
    }

    // Function to get EMR details for admin
    function getEMRDetails(uint256 tokenId, 
                                address EMR_Id) public view returns(uint,
                                                                        string memory, 
                                                                        string memory,
                                                                        string memory){

        // string memory _name = _capAC[tokenId].DoctorInfo[doctor_Id].name;
        // string memory _prescription = _capAC[tokenId].DoctorInfo[doctor_Id].prescription;

        return(_capAC[tokenId].id,
            _capAC[tokenId].EMRInfo[EMR_Id].patientname,
                _capAC[tokenId].EMRInfo[EMR_Id].authInstitutionNames,
                  _capAC[tokenId].EMRInfo[EMR_Id].treatment);
    }





    // get total tracker given a tokenId
    function total_tracker(uint256 tokenId) public view returns (uint256) {
        return _capAC[tokenId]._dataTracker.length;
    }

    // query DataTracker given token id
    function query_DataTracker(uint256 tokenId, uint256 index) public view returns (address, address) {
        require(index < _capAC[tokenId]._dataTracker.length, "NFT_Tracker: index out of bounds");

        return(_capAC[tokenId]._dataTracker[index].sender, 
            _capAC[tokenId]._dataTracker[index].receiver
            );      
    }

    function transfer(uint256 tokenId, address from, address to) public {
        // call NFT transfer
        super.transferFrom(from, to, tokenId);

        // update tracker
        _capAC[tokenId]._dataTracker.push( DataTracker(from, to) );

        emit OnDataTracker_Update(tokenId, _capAC[tokenId]._dataTracker.length);
    }
// ******* Before this bracket **********
}



