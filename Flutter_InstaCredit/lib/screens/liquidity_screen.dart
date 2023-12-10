import 'package:bnpl_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LiquidityScreen extends StatefulWidget {
  const LiquidityScreen({super.key});

  @override
  State<LiquidityScreen> createState() => _LiquidityScreenState();
}

class _LiquidityScreenState extends State<LiquidityScreen> {
  String _selectedChain = "";
  num _amount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(
              'assets/images/background.svg',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, left: 16),
                      child: Text(
                        "Liquidity Pool",
                        style: GoogleFonts.poppins(
                          color: gold,
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF434343).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF363636),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DefaultTabController(
                            length: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const TabBar(
                                  labelStyle: TextStyle(
                                    color: gold,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    color: Color(0xFFACACAC),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  indicator: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  tabs: [
                                    Tab(
                                      child: Text("Stake"),
                                    ),
                                    Tab(
                                      child: Text("Withdraw"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  height: deviceHeight(context) * 0.4,
                                  child: TabBarView(
                                    children: [
                                      ...List.generate(
                                        2,
                                        (index) => Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 40,
                                                bottom: 30,
                                              ),
                                              child: TextFormField(
                                                cursorColor: lightGold,
                                                initialValue:
                                                    _amount.toString(),
                                                onChanged: (val) {
                                                  if (num.tryParse(val) !=
                                                      null) {
                                                    setState(() {
                                                      _amount = num.parse(val);
                                                    });
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                  color: lightGold,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  label: Text("Amount"),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                                  filled: true,
                                                  fillColor: Color(0xFF202020),
                                                  constraints: BoxConstraints(),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: _selectedChain == ""
                                                  ? "Polygon"
                                                  : _selectedChain,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              decoration: const InputDecoration(
                                                fillColor: Color(0xFF202020),
                                                filled: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 18,
                                                ),
                                                constraints: BoxConstraints(),
                                                border: InputBorder.none,
                                              ),
                                              selectedItemBuilder: (context) {
                                                return [
                                                  "Polygon",
                                                  "Arbitrum",
                                                  "Scroll",
                                                  "Base",
                                                  "Celo"
                                                ]
                                                    .map(
                                                      (option) =>
                                                          DropdownMenuItem(
                                                        child: Text(
                                                          option,
                                                          style:
                                                              const TextStyle(
                                                            color: lightGold,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList();
                                              },
                                              items: [
                                                "Polygon",
                                                "Arbitrum",
                                                "Scroll",
                                                "Base",
                                                "Celo"
                                              ]
                                                  .map(
                                                    (option) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: option,
                                                      onTap: () => setState(() {
                                                        _selectedChain = option;
                                                      }),
                                                      child: Text(
                                                        option,
                                                        style: const TextStyle(
                                                          color: lightGold,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (String? val) {},
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 30,
                                              ),
                                              child: TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  backgroundColor: gold,
                                                  fixedSize: Size.fromWidth(
                                                    deviceWidth(context) * 0.7,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1),
                                                  ),
                                                ),
                                                child: Text(
                                                  index == 0
                                                      ? "Stake"
                                                      : "Withdraw",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF434343).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF363636),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Staked amount",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
