// ignore_for_file: unused_import

import 'package:bnpl_flutter/components/welcome_fragment.dart';
import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/screens/transaction_history.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
          const WelcomeFragment(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 80,
        index: 1,
        letIndexChange: (value) => false,
        backgroundColor: Colors.transparent,
        items: [
          CurvedNavigationBarItem(
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const TransactionHistoryScreen(),
                //   ),
                // );
                Fluttertoast.showToast(msg: "Coming soon...");
              },
              child: const Icon(
                Icons.swap_horiz_rounded,
                size: 30,
                color: Color(0xFFE0E0E0),
              ),
            ),
            label: "History",
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF717271),
            ),
          ),
          CurvedNavigationBarItem(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          const CurvedNavigationBarItem(
            child: Icon(
              Icons.person_rounded,
              size: 30,
              color: Color(0xFFE0E0E0),
            ),
            label: "Profile",
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF717271),
            ),
          ),
        ],
        buttonBackgroundColor: gold,
        color: const Color(0xFF2d2d2d),
      ),
    );
  }
}
