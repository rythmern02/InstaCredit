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

    
    // Event emitted when user document details are set
    event DocumentDetailsSet(
        address indexed user,
        docType nameOfDoc,
        string docIdentityNumber,
        string ipfsHashOfDoc,
        string ipfsHashofPan,
        uint256 panNumber
    );
    // Event emitted when user financial details are set
    event FinancialDetailsSet(
        address indexed user,
        uint256 creditLimit,
        uint256 cibilScore,
        uint256 time
    );

    // Event emitted when funds are given to a user
    event FundsGiven(address indexed user, uint256 amount, uint256 time);

    // Event emitted when a user makes a transaction
    event TransactionMade(address indexed user, uint256 amount, uint256 time);

    // Event emitted when a user pays back a loan
    event CreditPaidBack(
        address indexed user,
        uint256 amountPaid,
        uint256 time
    );

    function addCurrency(IERC20 _paytoken, AggregatorV3Interface _pricefeed)
        public
        onlyOwner
    {
        AllowedCrypto.push(
            TokenInfo({paytoken: _paytoken, priceFeed: _pricefeed})
        );
        emit CurrencyAdded(_paytoken, _pricefeed);
    }

    function setUserPersonalDetails(
        string memory firstName,
        string memory lastName,
        string memory fathersName,
        uint256 dateOfBirth,
        Gender gender
    ) public {
        User storage user = mapToUser[msg.sender];
        user.personalDetails.firstName = firstName;
        user.personalDetails.lastName = lastName;
        user.personalDetails.fathersName = fathersName;
        user.personalDetails.dateOfBirth = dateOfBirth;
        user.personalDetails.gender = gender;
        emit PersonalDetailsSet(
            msg.sender,
            firstName,
            lastName,
            fathersName,
            dateOfBirth,
            gender
        );
    }

    function setUserContactDetails(string memory email, uint256 mobile) public {
        User storage user = mapToUser[msg.sender];
        user.contactDetails.email = email;
        user.contactDetails.mobile = mobile;
        emit ContactDetailsSet(msg.sender, email, mobile);
    }

    function setUserDocumentDetails(
        docType nameOfDoc,
        string memory docIdentityNumber,
        string memory ipfsHashOfDoc,
        string memory ipfsHashofPan,
        uint256 panNumber
    ) public {
        User storage user = mapToUser[msg.sender];
        user.documentDetails.nameOfDoc = nameOfDoc;
        user.documentDetails.docIdentityNumber = docIdentityNumber;
        user.documentDetails.ipfsHashOfDoc = ipfsHashOfDoc;
        user.documentDetails.ipfsHashofPan = ipfsHashofPan;
        user.documentDetails.panNumber = panNumber;
        emit DocumentDetailsSet(
            msg.sender,
            nameOfDoc,
            docIdentityNumber,
            ipfsHashOfDoc,
            ipfsHashofPan,
            panNumber
        );
    }

    function setUserFinancialDetails(uint256 creditLimit, uint256 cibilScore)
        public
    {
        User storage user = mapToUser[msg.sender];
        user.financialDetails.creditLimit = creditLimit;
        user.financialDetails.cibilScore = cibilScore;
        user.financialDetails.borrowedAmount = 0;
        user.financialDetails.userBalance = 0;
        user.financialDetails.borrowedTimestamp = 0; // Initialize borrowedTimestamp to zero
        emit FinancialDetailsSet(
            msg.sender,
            creditLimit,
            cibilScore,
            block.timestamp
        );
    }

    function giveFunds(uint256 _amount) public {
        User storage user = mapToUser[msg.sender];
        require(
            user.financialDetails.cibilScore >= 750,
            "Insufficient CIBIL score"
        );
        require(
            user.financialDetails.creditLimit >= _amount,
            "Insufficient Credit Limit"
        );

        user.financialDetails.borrowedAmount += _amount;
        user.financialDetails.userBalance += _amount;
        user.financialDetails.creditLimit -= _amount;
        user.financialDetails.borrowedTimestamp = block.timestamp; // Set borrowedTimestamp when funds are given
        emit FundsGiven(msg.sender, _amount, block.timestamp);
    }

    function maketxn(uint256 _amount) public {
        User storage user = mapToUser[msg.sender];
        require(
            user.financialDetails.userBalance >= _amount,
            "Balance is Insufficient"
        );
        user.financialDetails.userBalance -= _amount;
        emit TransactionMade(msg.sender, _amount, block.timestamp);
    }

    function getLatestPrice(AggregatorV3Interface priceFeed)
        public
        view
        returns (int256)
    {
        (
            ,
            /*uint80 roundID*/
            int256 price, /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/
            ,
            ,

        ) = priceFeed.latestRoundData();
        return price;
    }

    
    function payBack(uint256 _tokenIndex) public {
        User storage user = mapToUser[msg.sender];
        require(
            user.financialDetails.borrowedAmount > 0,
            "No outstanding loan"
        );

        uint256 amount = user.financialDetails.borrowedAmount;
        TokenInfo storage tokens = AllowedCrypto[_tokenIndex];
        AggregatorV3Interface priceFeed = tokens.priceFeed;
        IERC20 paytoken = tokens.paytoken;

        // Get the current timestamp
        uint256 currentTime = block.timestamp;

        // Calculate the time difference in seconds
        uint256 timeDifference = currentTime -
            user.financialDetails.borrowedTimestamp;
        uint256 realTimeCost = (uint256(getLatestPrice(priceFeed)));
        require(realTimeCost > 0, "Invalid real-time cost");

        // Check if one year has passed
        if (timeDifference >= 31536000) {
            // User has not paid back till one year, charge 45% extra
            uint256 extraAmount = (amount * 45) / 100;
            uint256 totalAmountToBePaid = (realTimeCost *
                (amount + extraAmount)) / 100;
            paytoken.transferFrom(
                msg.sender,
                address(0xbA965BeBCfE338Fb92438EB50eaDFB38878Cfa8b),
                totalAmountToBePaid
            );

            // Reset borrowedAmount to zero
            user.financialDetails.borrowedAmount = 0;

            emit CreditPaidBack(msg.sender, totalAmountToBePaid, currentTime);
        } else {
            // User is paying before one year, charge 12% interest
            uint256 interestAmount = (amount * 12) / 100;
            uint256 totalAmountToBePaid = (realTimeCost *
                (amount + interestAmount)) / 100;
            paytoken.transferFrom(
                msg.sender,
                address(0xbA965BeBCfE338Fb92438EB50eaDFB38878Cfa8b),
                totalAmountToBePaid
            );

            // Reset borrowedAmount to zero
            user.financialDetails.borrowedAmount = 0;

            emit CreditPaidBack(msg.sender, totalAmountToBePaid, currentTime);
        }
    }

    function extendDeadline(uint256 _tokenIndex) public {
        User storage user = mapToUser[msg.sender];
        require(
            user.financialDetails.borrowedAmount > 0,
            "No outstanding loan"
        );

        uint256 amount = user.financialDetails.borrowedAmount;
        TokenInfo storage tokens = AllowedCrypto[_tokenIndex];
        AggregatorV3Interface priceFeed = tokens.priceFeed;
        IERC20 paytoken = tokens.paytoken;
         uint256 realTimeCost = (uint256(getLatestPrice(priceFeed)));

        // Calculate the interest for one month (12% annual interest)
        uint256 oneMonthInterest = (amount * 12) / 100 / 12;

        // Calculate the total amount to be paid for one month extension
        uint256 totalAmountToBePaid = (amount + oneMonthInterest) / 10;
        uint256 amountpaying = realTimeCost*(totalAmountToBePaid)/100;
        // Transfer 10% of the total amount to extend the deadline
        paytoken.transferFrom(
            msg.sender,
            address(0xbA965BeBCfE338Fb92438EB50eaDFB38878Cfa8b),
            amountpaying
        );

        // Update borrowedAmount and reset borrowedTimestamp
        user.financialDetails.borrowedAmount -= totalAmountToBePaid;
        user.financialDetails.borrowedTimestamp = block.timestamp;

        emit CreditPaidBack(msg.sender, totalAmountToBePaid, block.timestamp);
    }
}

//USDC Mumbai
//token address-- 0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747
// Chainlink Oracle pricefeed--   0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0
