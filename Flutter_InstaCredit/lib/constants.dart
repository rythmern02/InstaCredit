import 'dart:convert';

import 'package:flutter/material.dart';

const gold = Color(0xFFE4A432);
const lightGold = Color(0xFFFFE8BE);
const backgroundBlack = Color(0xFF141414);
const grey = Color(0xFF7C7C7C);

double deviceHeight(context) => MediaQuery.of(context).size.height;
double deviceWidth(context) => MediaQuery.of(context).size.width;

String abi() => jsonEncode(
      [
        {
          "inputs": [
            {"internalType": "address", "name": "owner", "type": "address"}
          ],
          "name": "OwnableInvalidOwner",
          "type": "error"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "account", "type": "address"}
          ],
          "name": "OwnableUnauthorizedAccount",
          "type": "error"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "email",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "mobile",
              "type": "uint256"
            }
          ],
          "name": "ContactDetailsSet",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amountPaid",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "CreditPaidBack",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "contract IERC20",
              "name": "paytoken",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "contract AggregatorV3Interface",
              "name": "priceFeed",
              "type": "address"
            }
          ],
          "name": "CurrencyAdded",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "enum CustodialWallet.docType",
              "name": "nameOfDoc",
              "type": "uint8"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "docIdentityNumber",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "ipfsHashOfDoc",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "ipfsHashofPan",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "panNumber",
              "type": "uint256"
            }
          ],
          "name": "DocumentDetailsSet",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "creditLimit",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "cibilScore",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "FinancialDetailsSet",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "FundsGiven",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "previousOwner",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "newOwner",
              "type": "address"
            }
          ],
          "name": "OwnershipTransferred",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "firstName",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "lastName",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "fathersName",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "dateOfBirth",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "enum CustodialWallet.Gender",
              "name": "gender",
              "type": "uint8"
            }
          ],
          "name": "PersonalDetailsSet",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "TransactionMade",
          "type": "event"
        },
        {
          "inputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "name": "AllowedCrypto",
          "outputs": [
            {
              "internalType": "contract IERC20",
              "name": "paytoken",
              "type": "address"
            },
            {
              "internalType": "contract AggregatorV3Interface",
              "name": "priceFeed",
              "type": "address"
            }
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "contract IERC20",
              "name": "_paytoken",
              "type": "address"
            },
            {
              "internalType": "contract AggregatorV3Interface",
              "name": "_pricefeed",
              "type": "address"
            }
          ],
          "name": "addCurrency",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "uint256",
              "name": "_tokenIndex",
              "type": "uint256"
            }
          ],
          "name": "extendDeadline",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "contract AggregatorV3Interface",
              "name": "priceFeed",
              "type": "address"
            }
          ],
          "name": "getLatestPrice",
          "outputs": [
            {"internalType": "int256", "name": "", "type": "int256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "uint256", "name": "_amount", "type": "uint256"}
          ],
          "name": "giveFunds",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "uint256", "name": "_amount", "type": "uint256"}
          ],
          "name": "maketxn",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "name": "mapToUser",
          "outputs": [
            {
              "components": [
                {
                  "internalType": "string",
                  "name": "firstName",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "lastName",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "fathersName",
                  "type": "string"
                },
                {
                  "internalType": "uint256",
                  "name": "dateOfBirth",
                  "type": "uint256"
                },
                {
                  "internalType": "enum CustodialWallet.Gender",
                  "name": "gender",
                  "type": "uint8"
                }
              ],
              "internalType": "struct CustodialWallet.PersonalDetails",
              "name": "personalDetails",
              "type": "tuple"
            },
            {
              "components": [
                {"internalType": "string", "name": "email", "type": "string"},
                {"internalType": "uint256", "name": "mobile", "type": "uint256"}
              ],
              "internalType": "struct CustodialWallet.ContactDetails",
              "name": "contactDetails",
              "type": "tuple"
            },
            {
              "components": [
                {
                  "internalType": "enum CustodialWallet.docType",
                  "name": "nameOfDoc",
                  "type": "uint8"
                },
                {
                  "internalType": "string",
                  "name": "docIdentityNumber",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "ipfsHashOfDoc",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "ipfsHashofPan",
                  "type": "string"
                },
                {
                  "internalType": "uint256",
                  "name": "panNumber",
                  "type": "uint256"
                }
              ],
              "internalType": "struct CustodialWallet.DocumentDetails",
              "name": "documentDetails",
              "type": "tuple"
            },
            {
              "components": [
                {
                  "internalType": "uint256",
                  "name": "creditLimit",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "cibilScore",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "borrowedAmount",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "userBalance",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "borrowedTimestamp",
                  "type": "uint256"
                }
              ],
              "internalType": "struct CustodialWallet.FinancialDetails",
              "name": "financialDetails",
              "type": "tuple"
            }
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "owner",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "uint256",
              "name": "_tokenIndex",
              "type": "uint256"
            }
          ],
          "name": "payBack",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "renounceOwnership",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "string", "name": "email", "type": "string"},
            {"internalType": "uint256", "name": "mobile", "type": "uint256"}
          ],
          "name": "setUserContactDetails",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "enum CustodialWallet.docType",
              "name": "nameOfDoc",
              "type": "uint8"
            },
            {
              "internalType": "string",
              "name": "docIdentityNumber",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "ipfsHashOfDoc",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "ipfsHashofPan",
              "type": "string"
            },
            {"internalType": "uint256", "name": "panNumber", "type": "uint256"}
          ],
          "name": "setUserDocumentDetails",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "uint256",
              "name": "creditLimit",
              "type": "uint256"
            },
            {"internalType": "uint256", "name": "cibilScore", "type": "uint256"}
          ],
          "name": "setUserFinancialDetails",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "string", "name": "firstName", "type": "string"},
            {"internalType": "string", "name": "lastName", "type": "string"},
            {"internalType": "string", "name": "fathersName", "type": "string"},
            {
              "internalType": "uint256",
              "name": "dateOfBirth",
              "type": "uint256"
            },
            {
              "internalType": "enum CustodialWallet.Gender",
              "name": "gender",
              "type": "uint8"
            }
          ],
          "name": "setUserPersonalDetails",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "newOwner", "type": "address"}
          ],
          "name": "transferOwnership",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        }
      ],
    );
