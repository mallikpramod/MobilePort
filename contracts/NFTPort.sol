// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract NFTPort is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("NFTPort", "NFTP") {}

    struct CSP{
        uint id;
        string name;
        address owner;
        uint [] allMobileNo;
    }

    struct MobileNo{
        uint tokenId;
        uint mobileNo;
        address owner;
        address user;
    }
    uint[] public allCSPIds;
    mapping(uint256 => CSP) public allCSP; // CSP_ID to CSP
    mapping(address=>CSP) public addressToCSP;
    mapping(uint256=> uint []) public allMobileNo; // CSP_ID to MobileNo
    mapping(uint=> MobileNo) public allMobileNoDetails; // MobileNo to MobileNoDetails
    mapping(string => uint) public allCSPName; // CSP_NAME to CSP_ID
    
    //create new CSP
    function createCSP(string memory _name, uint id) public onlyOwner {
        CSP storage newCSP = allCSP[id]; 
        newCSP.id = id;
        newCSP.name = _name;
        newCSP.owner = msg.sender;
        newCSP.allMobileNo = new uint[](0);
        allCSPIds.push(id);
       
        allCSPName[_name] = id;
        addressToCSP[msg.sender] = allCSP[id];
    }
    //Register new MobileNo
    //Calling function should be the owner of the CSP
    //Create a mobile Object attributes 1. mobile no 2. owner 3. tokenId
    //Add the mobile no to the CSP[owner]
    //Add the mobile no to the allMobileNoDetails

    function registerMobileNo(string  memory _cspName, uint _mobileNo) public returns(uint256){
        uint256 _cspId= allCSPName[_cspName];
        require(allCSP[_cspId].owner == msg.sender, "You are not the owner of this CSP");
        uint256 tokenId = _tokenIds.current();
        allMobileNo[_cspId].push(_mobileNo);
        MobileNo storage newMobileNo = allMobileNoDetails[_mobileNo];
        newMobileNo.tokenId = tokenId;
        newMobileNo.mobileNo = _mobileNo;
        newMobileNo.owner = msg.sender;
        allMobileNoDetails[_mobileNo] = newMobileNo;
        _tokenIds.increment();
        return tokenId;
    }

    //Transfer MobileNo
    //Change the address of the owner of the mobile no
    //Remove the number from the old CSP and add it to the new CSP


    function transferMobileNo(string memory _cspName, uint _mobileNo, string memory  _newOwner) public {
        uint256 _cspId= allCSPName[_cspName];
        uint256 _newCspId= allCSPName[_newOwner];
        require(allCSP[_cspId].owner == msg.sender, "You are not the owner of this CSP");
        require(allCSP[_newCspId].owner != msg.sender, "You are the owner of this CSP");
        allMobileNo[_cspId].push(_mobileNo);
        allMobileNoDetails[_mobileNo].owner = allCSP[_newCspId].owner;
        for(uint i=0;i<allMobileNo[_cspId].length;i++){
            if(allMobileNo[_cspId][i] == _mobileNo){
                delete allMobileNo[_cspId][i];
            }
        }

    }
    
    //Get all the CSP ids
    function getAllCSPIds() public view returns(uint[] memory){
        return allCSPIds;
    }
    
    //Get all the mobile no of a CSP
    function getAllMobileNo(string memory _cspName) public view returns(uint[] memory){
        uint256 _cspId= allCSPName[_cspName];
        return allMobileNo[_cspId];
    }

    //Get the details of a mobile no
    function getMobileNoDetails(uint _mobileNo) public view returns(MobileNo memory){
        return allMobileNoDetails[_mobileNo];
    }

    //Get the details of a CSP
    function getCSPDetails(string memory _cspName) public view returns(CSP memory){
        uint256 _cspId= allCSPName[_cspName];
        return allCSP[_cspId];
    }

    //Get the CSP of an address
    function getCSPByAddress(address _address) public view returns(CSP memory){
        return addressToCSP[_address];
    }

}


