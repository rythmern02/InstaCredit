// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:bnpl_flutter/screens/home_screen.dart';
import 'package:bnpl_flutter/screens/kyc_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3auth_flutter/enums.dart' as web3auth_enums;
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3dart/web3dart.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Fluttertoast.showToast(
      msg: "Loading...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("bnpl_flutter_priv_key") != null) {
      final authFunc = ref.watch(authStateProvider.notifier);
      authFunc.updateAuthState(
        credentials: EthPrivateKey.fromHex(
            prefs.getString("bnpl_flutter_priv_key") ?? "0"),
      );
      // const pushWallet = push.Wallet();
      await push.initPush(
        // wallet: Wallet(),
        env: push.ENV.staging,
      );
      if (prefs.getBool("kyc_done") ?? false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const KycScreen(),
          ),
          (route) => false,
        );
      }
      return;
    }

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('w3a://com.example.bnpl_flutter/auth');
    } else if (Platform.isIOS) {
      redirectUrl = Uri.parse('com.bnpl.bnpl-app://auth');
    } else {
      throw UnKnownException('Unknown platform');
    }

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId:
            "BA9qlOl-vgJxjZw4BTMRXj-HFpJH6CWa5_NGA5WU7-IJ1NCBPo0LT-LpNW-lVgkb9xjBXEVOQAnA_adJlMixAiE",
        network: web3auth_enums.Network.sapphire_devnet,
        redirectUrl: redirectUrl,
      ),
    );

    await Web3AuthFlutter.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final authStateFunc = ref.watch(authStateProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/images/background.svg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      color: gold,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Text(
                    "Use Google authentication to login or create a new account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final Web3AuthResponse response =
                          await Web3AuthFlutter.login(
                        LoginParams(
                          loginProvider: web3auth_enums.Provider.google,
                          curve: web3auth_enums.Curve.secp256k1,
                        ),
                      );

                      final prefs = await SharedPreferences.getInstance();

                      final credentials =
                          EthPrivateKey.fromHex(response.privKey ?? '0');
                      print(credentials.address.hexEip55);

                      authStateFunc.updateAuthState(
                        email: response.userInfo!.email,
                        credentials: credentials,
                        firstName: response.userInfo!.name?.split(" ").first,
                        lastName: response.userInfo!.name?.split(" ").last,
                      );

                      prefs.setString(
                        "bnpl_flutter_priv_key",
                        response.privKey.toString(),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KycScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
