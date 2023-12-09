import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/design/textfield.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactInfo extends ConsumerStatefulWidget {
  const ContactInfo({super.key});

  @override
  ConsumerState<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends ConsumerState<ContactInfo> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final authFunc = ref.watch(authStateProvider.notifier);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                "Contact Information",
                style: TextStyle(
                  color: gold,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12, top: 28),
              child: Text(
                "Email Address",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CustomTextfield(
              value: auth.email,
              onChange: (value) {
                authFunc.updateAuthState(email: value);
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12, top: 30),
              child: Text(
                "Phone Number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CustomTextfield(
              value: auth.phoneNumber,
              inputType: TextInputType.phone,
              onChange: (value) {
                authFunc.updateAuthState(phoneNumber: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
