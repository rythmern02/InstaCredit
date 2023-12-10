import 'package:flutter/material.dart';

class LiquiditySuccess extends StatefulWidget {
  const LiquiditySuccess({super.key});

  @override
  State<LiquiditySuccess> createState() => _LiquiditySuccessState();
}

class _LiquiditySuccessState extends State<LiquiditySuccess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 376,
      height: 812,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -13,
            top: 129,
            child: Container(
              width: 401,
              height: 448,
              child: Stack(children: []),
            ),
          ),
          Positioned(
            left: 304,
            top: 894,
            child: Container(
              width: 56,
              height: 56,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: ShapeDecoration(
                        color: Color(0xFFE4A432),
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 1.50,
                            color:
                                Colors.white.withOpacity(0.23999999463558197),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 37,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-1.57),
                      child: Container(
                        width: 24,
                        height: 24,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(children: []),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 91,
            top: 156,
            child: Container(
              width: 194,
              height: 194,
              decoration: ShapeDecoration(
                color: Color(0xFFE4A432),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 59,
            top: 389,
            child: SizedBox(
              width: 259,
              child: Text(
                'congratulation your\n amount has staked',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
