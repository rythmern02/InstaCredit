// ignore_for_file: avoid_print

import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:bnpl_flutter/services/ipfs_service.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ContractService {
  static const mumbaiRpc =
      "https://polygon-mumbai.infura.io/v3/fe22b857418f4cbbbbe6fee96cf49a65";
  static const celoRpc =
      "https://celo-alfajores.infura.io/v3/fe22b857418f4cbbbbe6fee96cf49a65";
  static const arbitrumSepoliaRpc =
      "https://arbitrum-sepolia.blockpi.network/v1/rpc/public	";
  static const baseSepoliaRpc = "https://sepolia.base.org/";
  static const scrollSepoliaRpc =
      "https://scroll-sepolia.blockpi.network/v1/rpc/public";
  static final celoContract =
      EthereumAddress.fromHex("0x707a124485314C30310C83E4b06A53E46cb9069a");
  static final arbitrumContract =
      EthereumAddress.fromHex("0xf4D67eb676d5DA2620E47f7Df7366DAFA8295337");
  static final baseContract =
      EthereumAddress.fromHex("0xf4D67eb676d5DA2620E47f7Df7366DAFA8295337");
  static final scrollContract =
      EthereumAddress.fromHex("0xf4D67eb676d5DA2620E47f7Df7366DAFA8295337");

  static final httpClient = Client();
  static Web3Client ethClient = Web3Client(
    mumbaiRpc,
    httpClient,
  );
  static DeployedContract bnplContract = DeployedContract(
    ContractAbi.fromJson(abi(), 'CustodialWallet'),
    EthereumAddress.fromHex("0xcf0AE14239a2D70f37354389b90044C98b1A4619"),
  );
  static DeployedContract liquidityContract = DeployedContract(
    ContractAbi.fromJson(liquidityAbi(), 'LiquidityPool'),
    EthereumAddress.fromHex("0xa0CbaD0e730c3435c37A5393f0B6B4Cec0327b29"),
  );
  static final setPersonalDetails =
      bnplContract.function('setUserPersonalDetails');
  static final setContactDetails =
      bnplContract.function('setUserContactDetails');
  static final setDocumentDetails =
      bnplContract.function('setUserDocumentDetails');
  static final setFinancialDetails =
      bnplContract.function('setUserFinancialDetails');
  static final giveFunds = bnplContract.function("giveFunds");
  static final makeTxn = bnplContract.function("maketxn");

  static switchChain({required String chainName}) async {
    switch (chainName) {
      case "Celo":
        ethClient = Web3Client(
          celoRpc,
          httpClient,
        );
        bnplContract = DeployedContract(
          ContractAbi.fromJson(abi(), 'CustodialWallet'),
          celoContract,
        );
        break;

      case "Base":
        ethClient = Web3Client(
          baseSepoliaRpc,
          httpClient,
        );
        bnplContract = DeployedContract(
          ContractAbi.fromJson(abi(), 'CustodialWallet'),
          baseContract,
        );
        break;

      case "Scroll":
        ethClient = Web3Client(
          scrollSepoliaRpc,
          httpClient,
        );
        bnplContract = DeployedContract(
          ContractAbi.fromJson(abi(), 'CustodialWallet'),
          scrollContract,
        );
        break;

      case "Arbitrum":
        ethClient = Web3Client(
          arbitrumSepoliaRpc,
          httpClient,
        );
        bnplContract = DeployedContract(
          ContractAbi.fromJson(abi(), 'CustodialWallet'),
          arbitrumContract,
        );
        break;

      default:
        ethClient = Web3Client(
          mumbaiRpc,
          httpClient,
        );
        bnplContract = DeployedContract(
          ContractAbi.fromJson(abi(), 'CustodialWallet'),
          EthereumAddress.fromHex("0xcf0AE14239a2D70f37354389b90044C98b1A4619"),
        );
    }
  }

  static initUser({
    required AuthState auth,
  }) async {
    try {
      final ipfsService = IpfsService();
      var personalResult = await ethClient.sendTransaction(
        auth.credentials,
        Transaction.callContract(
          contract: bnplContract,
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
          contract: bnplContract,
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
          contract: bnplContract,
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
          contract: bnplContract,
          function: setFinancialDetails,
          parameters: [BigInt.from(250), BigInt.from(1000)],
        ),
        chainId: 80001,
      );

      print(financeResult.toString());

      Future.delayed(Duration(seconds: 2), () async {
        var fundingRes = await ethClient.sendTransaction(
          auth.credentials,
          Transaction.callContract(
            contract: bnplContract,
            function: giveFunds,
            parameters: [BigInt.from(250)],
          ),
          chainId: 80001,
        );

        print(fundingRes);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List> fetchUserData({
    required Credentials credentials,
  }) async {
    final mapToUser = bnplContract.function('mapToUser');
    var result2 = await ethClient.call(
      sender: credentials.address,
      contract: bnplContract,
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

  static fetchAmountToPayBack({
    required Credentials credentials,
  }) async {
    final res = await fetchUserData(credentials: credentials);
    return res.last[2];
  }

  static makePayment({
    required Credentials credentials,
    required double amount,
  }) async {
    var res = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: bnplContract,
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
