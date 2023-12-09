// ignore_for_file: avoid_print

import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:bnpl_flutter/services/ipfs_service.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ContractService {
  static final httpClient = Client();
  static final ethClient = Web3Client(
    "https://polygon-mumbai.infura.io/v3/fe22b857418f4cbbbbe6fee96cf49a65",
    httpClient,
  );
  static final contract = DeployedContract(
    ContractAbi.fromJson(abi(), 'CustodialWallet'),
    EthereumAddress.fromHex("0x25597ef8243d904864ac41332c038144F0BdDE99"),
  );
  static final setPersonalDetails = contract.function('setUserPersonalDetails');
  static final setContactDetails = contract.function('setUserContactDetails');
  static final setDocumentDetails = contract.function('setUserDocumentDetails');
  static final setFinancialDetails =
      contract.function('setUserFinancialDetails');
  static final giveFunds = contract.function("giveFunds");
  static final makeTxn = contract.function("maketxn");

  static initUser({
    required AuthState auth,
  }) async {
    try {
      final ipfsService = IpfsService();
      var personalResult = await ethClient.sendTransaction(
        auth.credentials,
        Transaction.callContract(
          contract: contract,
          function: setPersonalDetails,
          parameters: [
            auth.firstName,
            auth.lastName,
            auth.fathersName,
            BigInt.from(auth.dob.millisecondsSinceEpoch),
            BigInt.from(auth.gender == "Male" ? 0 : 1)
          ],
        ),
        chainId: 80001,
      );

      print(personalResult.toString());

      var contactResult = await ethClient.sendTransaction(
        auth.credentials,
        Transaction.callContract(
          contract: contract,
          function: setContactDetails,
          parameters: [
            auth.email,
            BigInt.parse(auth.phoneNumber),
          ],
        ),
        chainId: 80001,
      );

      print(contactResult.toString());

      final docCid =
          await ipfsService.uploadToIpfs(auth.idDocFile.readAsBytesSync());
      final panCid =
          await ipfsService.uploadToIpfs(auth.panDocFile.readAsBytesSync());

      var docResult = await ethClient.sendTransaction(
        auth.credentials,
        Transaction.callContract(
          contract: contract,
          function: setDocumentDetails,
          parameters: [
            BigInt.from(auth.idDoc == "Aadhar Card" ? 1 : 0),
            auth.idNumber,
            docCid,
            panCid,
            BigInt.from(auth.panNumber.hashCode),
          ],
        ),
        chainId: 80001,
      );

      print(docResult.toString());

      var financeResult = await ethClient.sendTransaction(
        auth.credentials,
        Transaction.callContract(
          contract: contract,
          function: setFinancialDetails,
          parameters: [BigInt.from(250), BigInt.from(1000)],
        ),
        chainId: 80001,
      );

      print(financeResult.toString());

      var fundingRes = await ethClient.sendTransaction(
        auth.credentials,
        Transaction.callContract(
          contract: contract,
          function: giveFunds,
          parameters: [BigInt.from(250)],
        ),
        chainId: 80001,
      );

      print(fundingRes);
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchUserData({
    required Credentials credentials,
  }) async {
    final mapToUser = contract.function('mapToUser');
    var result2 = await ethClient.call(
      sender: credentials.address,
      contract: contract,
      function: mapToUser,
      params: [credentials.address],
    );
    print(result2.toString());
    return result2;
  }

  static fetchBalance({
    required Credentials credentials,
  }) async {
    final res = await fetchUserData(credentials: credentials);
    return res.last[3];
  }

  static makePayment({
    required Credentials credentials,
    required double amount,
  }) async {
    var res = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: makeTxn,
        parameters: [
          BigInt.from(amount),
        ],
      ),
      chainId: 80001,
    );

    print(res.toString());
  }
}
