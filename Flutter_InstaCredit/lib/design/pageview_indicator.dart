import 'package:flutter/material.dart';

class PageviewIndicator extends StatefulWidget {
  final int page;
  final int total;

  const PageviewIndicator({
    super.key,
    required this.page,
    required this.total,
  });

  @override
  State<PageviewIndicator> createState() => _PageviewIndicatorState();
}

class _PageviewIndicatorState extends State<PageviewIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: List.generate(
          widget.total,
          (index) => Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: index <= widget.page
                    ? const Color(0xFFE4A432)
                    : Colors.white,
                borderRadius: BorderRadius.circular(1000),
              ),
              height: 5,
            ),
          ),
        ),
      ),
    );
  }
}
