// ignore_for_file: unused_field

import 'package:bnpl_flutter/components/brand_list.dart';
import 'package:bnpl_flutter/components/dashboard_component.dart';
import 'package:bnpl_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeFragment extends ConsumerStatefulWidget {
  const WelcomeFragment({super.key});

  @override
  ConsumerState<WelcomeFragment> createState() => _WelcomeFragmentState();
}

class _WelcomeFragmentState extends ConsumerState<WelcomeFragment> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to",
              style: TextStyle(
                color: grey,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
                children: const [
                  TextSpan(
                    text: "Insta",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "Credit",
                    style: TextStyle(
                      color: gold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  DashboardComponent(
                    switchBrands: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                      );
                    },
                  ),
                  BrandList(
                    onBackPressed: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
