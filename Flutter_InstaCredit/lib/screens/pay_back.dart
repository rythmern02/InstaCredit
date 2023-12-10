import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:bnpl_flutter/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayBack extends ConsumerStatefulWidget {
  const PayBack({super.key});

  @override
  ConsumerState<PayBack> createState() => _PayBackState();
}

class _PayBackState extends ConsumerState<PayBack> {
  String _selectedChain = "";
  bool _loading = true;
  double _balance = 0;
  bool _payedBack = false;

  initBalance() async {
    if (!_loading) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("payed_back") != null) {
      if (sharedPreferences.getBool("payed_back")!) {
        setState(() {
          _payedBack = true;
          _loading = false;
        });
      }
    }
    final auth = ref.watch(authStateProvider);
    final val = await ContractService.fetchAmountToPayBack(
        credentials: auth.credentials);

    setState(() {
      _balance = (val as BigInt).toDouble();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    initBalance();
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Text(
                      "Pay your Credit Balance now",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedChain == "" ? "Polygon" : _selectedChain,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: const InputDecoration(
                      fillColor: Color(0xFF202020),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 18,
                      ),
                      constraints: BoxConstraints(),
                      border: InputBorder.none,
                    ),
                    selectedItemBuilder: (context) {
                      return ["Polygon", "Arbitrum", "Scroll", "Base", "Celo"]
                          .map(
                            (option) => DropdownMenuItem(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  color: lightGold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          )
                          .toList();
                    },
                    items: ["Polygon", "Arbitrum", "Scroll", "Base", "Celo"]
                        .map(
                          (option) => DropdownMenuItem<String>(
                            value: option,
                            onTap: () {
                              setState(() {
                                _selectedChain = option;
                              });
                              ContractService.switchChain(chainName: option);
                            },
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: lightGold,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? val) {},
                  ),
                  if (!_loading && _payedBack)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Balance has been payed back.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 185, 173, 173),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  if (!_loading && !_payedBack) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Pay \$$_balance at the following address:",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 185, 173, 173),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        auth.credentials.address.hexEip55,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                              text: auth.credentials.address.hexEip55),
                        );
                        Fluttertoast.showToast(msg: "Copied");
                        Future.delayed(const Duration(seconds: 20), () async {
                          setState(() {
                            _payedBack = true;
                          });
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setBool("payed_back", true);
                        });
                      },
                      child: const Text(
                        "Copy Address",
                        style: TextStyle(
                          color: gold,
                        ),
                      ),
                    ),
                  ],
                  if (_loading)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: CircularProgressIndicator(
                        color: gold,
                      ),
                    )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
