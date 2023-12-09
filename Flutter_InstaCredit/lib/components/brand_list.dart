import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/screens/product_list_screen.dart';
import 'package:flutter/material.dart';

class BrandList extends StatefulWidget {
  final void Function() onBackPressed;
  const BrandList({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<BrandList> createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: widget.onBackPressed,
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
          padding: EdgeInsets.only(top: 32, left: 8),
          child: Text(
            "Brands",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF919191),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF363636),
            ),
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductListScreen(),
              ),
            ),
            child: Container(
              height: deviceHeight(context) * 0.2,
              padding: const EdgeInsets.only(bottom: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/images/gucci_brand.png"),
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "GUCCI Products",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
