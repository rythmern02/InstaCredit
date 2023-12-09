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
}
