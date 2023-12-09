import 'package:bnpl_flutter/constants.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String value;
  final void Function(String)? onChange;
  final TextInputType? inputType;

  const CustomTextfield({
    super.key,
    required this.value,
    required this.onChange,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: lightGold,
      initialValue: value,
      onChanged: onChange,
      keyboardType: inputType,
      style: const TextStyle(
        color: lightGold,
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        constraints: const BoxConstraints(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(
            color: Color(0xffb5b5b55e),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(
            color: gold,
          ),
        ),
      ),
    );
  }
}
