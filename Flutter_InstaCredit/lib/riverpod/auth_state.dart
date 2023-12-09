import 'dart:io';
import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';
import 'package:web3dart/web3dart.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    AuthState(
      dob: DateTime.now(),
      email: '',
      idDoc: "Aadhar Card",
      fathersName: '',
      firstName: '',
      gender: "Male",
      idDocFile: File(""),
      idNumber: '',
      lastName: '',
      panDocFile: File(""),
      panNumber: '',
      phoneNumber: '',
      credentials: EthPrivateKey(Uint8List.fromList([0])),
    ),
  );
});

class AuthState {
  String email;
  EthPrivateKey credentials;
  String firstName;
  String lastName;
  String fathersName;
  DateTime dob;
  String gender;
  String phoneNumber;
  String idDoc;
  String idNumber;
  File idDocFile;
  String panNumber;
  File panDocFile;

  AuthState({
    required this.dob,
    required this.email,
    required this.fathersName,
    required this.firstName,
    required this.gender,
    required this.idDoc,
    required this.idDocFile,
    required this.idNumber,
    required this.lastName,
    required this.panDocFile,
    required this.panNumber,
    required this.phoneNumber,
    required this.credentials,
  });
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(AuthState state) : super(state);

  updateAuthState({
    String? email,
    String? firstName,
    String? lastName,
    String? fathersName,
    DateTime? dob,
    String? gender,
    String? phoneNumber,
    String? idDoc,
    String? idNumber,
    File? idDocFile,
    String? panNumber,
    File? panDocFile,
    EthPrivateKey? credentials,
  }) {
    state = AuthState(
      dob: dob ?? state.dob,
      email: email ?? state.email,
      idDoc: idDoc ?? state.idDoc,
      fathersName: fathersName ?? state.fathersName,
      firstName: firstName ?? state.firstName,
      gender: gender ?? state.gender,
      idDocFile: idDocFile ?? state.idDocFile,
      idNumber: idNumber ?? state.idNumber,
      lastName: lastName ?? state.lastName,
      panDocFile: panDocFile ?? state.panDocFile,
      panNumber: panNumber ?? state.panNumber,
      phoneNumber: phoneNumber ?? state.phoneNumber,
      credentials: credentials ?? state.credentials,
    );
  }

  clearState() {
    state = AuthState(
      dob: DateTime.now(),
      email: '',
      idDoc: "Aadhar Card",
      fathersName: '',
      firstName: '',
      gender: "Male",
      idDocFile: File(""),
      idNumber: '',
      lastName: '',
      panDocFile: File(""),
      panNumber: '',
      phoneNumber: '',
      credentials: EthPrivateKey(Uint8List.fromList([0])),
    );
  }
}
