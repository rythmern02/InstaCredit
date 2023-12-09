import 'package:bnpl_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownBox extends ConsumerStatefulWidget {
  final List<String> items;
  final void Function(String value) onTap;
  final String value;
  const DropdownBox({
    Key? key,
    required this.items,
    required this.onTap,
    required this.value,
  }) : super(key: key);

  @override
  ConsumerState<DropdownBox> createState() => _DropdownBoxState();
}

class _DropdownBoxState extends ConsumerState<DropdownBox> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.value,
      icon: const Icon(Icons.keyboard_arrow_down),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        constraints: const BoxConstraints(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(
            color: Color.fromRGBO(130, 146, 229, 1),
            width: 0.5,
          ),
        ),
      ),
      selectedItemBuilder: (context) {
        return widget.items
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
      items: widget.items
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              onTap: () => widget.onTap(option),
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
    );
  }
}
