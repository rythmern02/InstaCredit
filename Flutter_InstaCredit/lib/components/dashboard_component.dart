import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:bnpl_flutter/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardComponent extends ConsumerStatefulWidget {
  final void Function() switchBrands;
  const DashboardComponent({
    super.key,
    required this.switchBrands,
  });

  @override
  ConsumerState<DashboardComponent> createState() => _DashboardComponentState();
}

class _DashboardComponentState extends ConsumerState<DashboardComponent> {
  bool _loadingBalance = true;
  double _balance = 0;

  initBalance() async {
    if (!_loadingBalance) return;
    final auth = ref.watch(authStateProvider);
    final val =
        await ContractService.fetchBalance(credentials: auth.credentials);

    setState(() {
      _balance = (val as BigInt).toDouble();
      _loadingBalance = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    initBalance();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * 0.1),
          child: Center(
            child: CircularPercentIndicator(
              radius: 130,
              lineWidth: 10,
              arcBackgroundColor: Colors.white,
              arcType: ArcType.HALF,
              circularStrokeCap: CircularStrokeCap.round,
              animateFromLastPercent: true,
              animation: true,
              curve: Curves.easeIn,
              percent: _balance / 250,
              progressColor: gold,
              center: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_loadingBalance)
                      Text(
                        "\$$_balance",
                        style: const TextStyle(
                          color: Color(0xFFE6E6E6),
                          fontSize: 45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    if (_loadingBalance)
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    if (!_loadingBalance)
                      Text(
                        "${(_balance / 250 * 100).round()}% left",
                        style: const TextStyle(
                          color: Color(0xFF9d9d9d),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    const Text(
                      "Balance",
                      style: TextStyle(
                        color: gold,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            ...["NFT", "Stakes", "Brands"].map(
              (item) => Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      if (item == "Brands") {
                        widget.switchBrands();
                      } else {
                        Fluttertoast.showToast(msg: "Coming soon...");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF272727),
                      shadowColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 14,
            bottom: deviceHeight(context) * 0.1,
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF272727),
              shadowColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              fixedSize: const Size.fromWidth(double.maxFinite),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              "Pay Balance",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
