// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bnpl_flutter/components/contact_info.dart';
import 'package:bnpl_flutter/components/document_upload.dart';
import 'package:bnpl_flutter/components/personal_info.dart';
import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/design/pageview_indicator.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:bnpl_flutter/screens/profile_complete.dart';
import 'package:bnpl_flutter/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 36, left: 16),
                child: Row(
                  children: [
                    Text(
                      "KYC",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              PageviewIndicator(page: _currentPage, total: 3),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    PersonalInfoView(),
                    ContactInfo(),
                    DocumentUpload()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_currentPage < 2) {
                      if (_currentPage == 0) {
                        if (auth.firstName == "" ||
                            auth.lastName == "" ||
                            auth.fathersName == "" ||
                            auth.gender == "") {
                          Fluttertoast.showToast(
                            msg: "Please fill the above details fully.",
                          );
                          return;
                        }

                        if (DateTime.now().difference(auth.dob) <
                            const Duration(hours: 24, days: 0)) {
                          Fluttertoast.showToast(
                            msg: "Please fill correct DOB",
                          );
                          return;
                        }
                      }
                      if (_currentPage == 1) {
                        if (auth.email == "" || auth.phoneNumber == "") {
                          Fluttertoast.showToast(
                            msg: "Please fill the above details fully.",
                          );
                          return;
                        }
                      }
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                      );
                    } else {
                      if (auth.idDoc == "" ||
                          auth.idNumber == "" ||
                          auth.panNumber == "" ||
                          auth.idDocFile == File("") ||
                          auth.panDocFile == File("")) {
                        Fluttertoast.showToast(
                          msg: "Please fill the above details fully.",
                        );
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("kyc_done", true);
                      await ContractService.initUser(auth: auth);
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileCompleteScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentPage == 2 ? "Submit" : "Next",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: _currentPage == 2
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      if (_currentPage < 2)
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      if (_currentPage == 2 && _isLoading)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
