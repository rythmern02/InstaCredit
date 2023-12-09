import 'package:intl/intl.dart';
import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DobSelectorField extends ConsumerStatefulWidget {
  const DobSelectorField({super.key});

  @override
  ConsumerState<DobSelectorField> createState() => _DobSelectorFieldState();
}

class _DobSelectorFieldState extends ConsumerState<DobSelectorField> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final authFunc = ref.watch(authStateProvider.notifier);
    return TextFormField(
      readOnly: true,
      cursorColor: lightGold,
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: DateFormat('dd-MM-yyyy').format(auth.dob.toLocal()),
        ),
      ),
      onTap: () async {
        DateTime? date = DateTime(1900);
        FocusScope.of(context).requestFocus(FocusNode());
        date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          locale: const Locale("en", "IN"),
        );

        if (date != null && mounted) {
          authFunc.updateAuthState(dob: date);
        }
      },
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
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
