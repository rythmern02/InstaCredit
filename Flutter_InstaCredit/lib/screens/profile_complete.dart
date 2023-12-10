import 'dart:math';

import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:confetti/confetti.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  late ConfettiController controllerTopCenter;

  @override
  void initState() {
    super.initState();
    controllerTopCenter = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    controllerTopCenter.play();
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 18.0),
                  child: Text(
                    "Congratulations",
                    style: TextStyle(
                      color: gold,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  "You",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "Have A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "Credit Limit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "of",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "\$250",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                  ),
                  child: const Text(
                    "Spend Now",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Stack(
                children: [
                  ConfettiWidget(
                    shouldLoop: false,
                    confettiController: controllerTopCenter,
                    blastDirection: (pi + 1.25),
                    blastDirectionality: BlastDirectionality.directional,
                    maxBlastForce: 100, // set a lower max blast force
                    minBlastForce: 8, // set a lower min blast force
                    emissionFrequency: 1,
                    numberOfParticles: 4,
                    gravity: 0.5,
                  ),
                  ConfettiWidget(
                    shouldLoop: false,
                    confettiController: controllerTopCenter,
                    blastDirection: (pi + 1.75),
                    blastDirectionality: BlastDirectionality.directional,
                    maxBlastForce: 100, // set a lower max blast force
                    minBlastForce: 8, // set a lower min blast force
                    emissionFrequency: 1,
                    numberOfParticles: 4,
                    gravity: 0.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
