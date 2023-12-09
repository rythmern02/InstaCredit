// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@0xPolygonID/contracts/Verifier.sol";

contract PANVerifier is Ownable {
    // Address of the Polygon ID validator contract
    address public validatorAddress;

    // Mapping to store user PAN and verification status
    mapping(string => bool) public verifiedPANs;

    // Event emitted when a PAN is verified
    event PANVerified(string pan, address user);

    constructor(address _validatorAddress) {
        validatorAddress = _validatorAddress;
    }

    // Function for users to submit PAN and proof for verification
    function submitPAN(string memory _pan, bytes memory _proof) public {
        require(!verifiedPANs[_pan], "PAN already verified");

        // Verify proof using Polygon ID library
        verifyProof(_proof, validatorAddress);

        verifiedPANs[_pan] = true;
        emit PANVerified(_pan, msg.sender);
    }

    // Function for verifying a proof using Polygon ID
    function verifyProof(bytes memory _proof, address _validatorAddress) internal {
        // Use Verifier contract to verify the proof
        bool success = Verifier(_validatorAddress).verify(_proof);

        require(success, "Proof verification failed");
    }

    // Function to check if a PAN is verified
    function isPANVerified(string memory _pan) public view returns (bool) {
        return verifiedPANs[_pan];
    }
}
