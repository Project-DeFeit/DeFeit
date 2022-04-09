// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract Defeit {
    address owner;

    struct drugCode {
        uint256 status;
        string drugName;
        string contents;
        string manufacturer;
        string manufacturingUnit;
        string batch;
        string seller;
        string[] customers;
    }

    struct consumerProfile {
        string name;
        string phone;
        string[] code;
        bool isValue;
    }

    struct sellerProfile {
        string name;
        string location;
    }

    mapping(string => drugCode) drugcodeArray;
    mapping(string => consumerProfile) consumersArray;
    mapping(string => sellerProfile) sellerArray;

    function generateCode(
        string _code,
        string _drugName,
        uint256 _status,
        string _contents,
        string _manufacturer,
        string _manufacturingUnit,
        string _batch
    ) public payable returns (uint256) {
        drugCode newCode;
        newCode.drugName = _drugName;
        newCode.status = _status;
        newCode.contents = _contents;
        newCode.manufacturer = _manufacturer;
        newCode.manufacturingUnit = _manufacturingUnit;
        newCode.batch = _batch;
        drugcodeArray[_code] = newCode;
        return 1;
    }

    function getDrugDetails(string _code)
        public
        view
        returns (
            string,
            uint256,
            string,
            string,
            string,
            string
        )
    {
        return (
            drugcodeArray[_code].drugName,
            drugcodeArray[_code].status,
            drugcodeArray[_code].contents,
            drugcodeArray[_code].manufacturer,
            drugcodeArray[_code].manufacturingUnit,
            drugcodeArray[_code].batch
        );
    }

    function addSellerToCode(string _code, string _hashedEmailSeller)
        public
        payable
        returns (uint256)
    {
        drugcodeArray[_code].seller = _hashedEmailSeller;
        return 1;
    }

    function createCustomer(
        string _hashedEmail,
        string _name,
        string _phone
    ) public payable returns (bool) {
        if (consumersArray[_hashedEmail].isValue) {
            return false;
        }
        consumerProfile newCustomer;
        newCustomer.name = _name;
        newCustomer.phone = _phone;
        newCustomer.isValue = true;
        consumersArray[_hashedEmail] = newCustomer;
        return true;
    }

    function getCustomerDetails(string _code)
        public
        view
        returns (string, string)
    {
        return (consumersArray[_code].name, consumersArray[_code].phone);
    }

    function createSeller(
        string _hashedEmail,
        string _sellerName,
        string _sellerLocation
    ) public payable returns (uint256) {
        sellerProfile newSeller;
        newSeller.name = _sellerName;
        newSeller.location = _sellerLocation;
        sellerArray[_hashedEmail] = newSeller;
        return 1;
    }

    function getSellerDetails(string _code)
        public
        view
        returns (string, string)
    {
        return (sellerArray[_code].name, sellerArray[_code].location);
    }

    function compareStrings(string a, string b) internal returns (bool) {
        return keccak256(a) == keccak256(b);
    }

    function remove(uint256 index, string[] storage array)
        internal
        returns (bool)
    {
        if (index >= array.length) return false;

        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        delete array[array.length - 1];
        array.length--;
        return true;
    }

    function stringToBytes32(string memory source)
        internal
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }
}
