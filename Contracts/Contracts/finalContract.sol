// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustodialWallet is Ownable(msg.sender) {
    // structure of token information
    struct TokenInfo {
        IERC20 paytoken;
        AggregatorV3Interface priceFeed;
    }

    // enum for gender
    enum Gender {
        male,
        female
    }

    // enum for identity document type
    enum docType {
        drivingLicense,
        aadhar,
        passport,
        voterId
    }

    // structure for personal details of the user
    struct PersonalDetails {
        string firstName;
        string lastName;
        string fathersName;
        uint256 dateOfBirth;
        Gender gender;
    }

    // structure for Contact details of the user
    struct ContactDetails {
        string email;
        uint256 mobile;
    }

    // structure for Document details
    struct DocumentDetails {
        docType nameOfDoc;
        string docIdentityNumber;
        string ipfsHashOfDoc;
        string ipfsHashofPan;
        uint256 panNumber;
    }

    struct FinancialDetails {
        uint256 creditLimit;
        uint256 cibilScore;
        uint256 borrowedAmount;
        uint256 userBalance;
        uint256 borrowedTimestamp; // New field to store the timestamp when the amount was borrowed
    }

    struct User {
        PersonalDetails personalDetails;
        ContactDetails contactDetails;
        DocumentDetails documentDetails;
        FinancialDetails financialDetails;
    }

    // mapping for user to link with address
    mapping(address => User) public mapToUser;

    TokenInfo[] public AllowedCrypto;

    // Event emitted when a new currency is added
    event CurrencyAdded(
        IERC20 indexed paytoken,
        AggregatorV3Interface indexed priceFeed
    );

    // Event emitted when user personal details are set
    event PersonalDetailsSet(
        address indexed user,
        string firstName,
        string lastName,
        string fathersName,
        uint256 dateOfBirth,
        Gender gender
    );

    // Event emitted when user contact details are set
    event ContactDetailsSet(address indexed user, string email, uint256 mobile);
}

//USDC Mumbai
//token address-- 0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747
// Chainlink Oracle pricefeed--   0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0
