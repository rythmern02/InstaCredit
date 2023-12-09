import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/design/dob_selector.dart';
import 'package:bnpl_flutter/design/dropdown.dart';
import 'package:bnpl_flutter/design/textfield.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoView extends ConsumerStatefulWidget {
  const PersonalInfoView({super.key});

  @override
  ConsumerState<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends ConsumerState<PersonalInfoView> {
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
              padding: EdgeInsets.only(bottom: 38, top: 32),
              child: Text(
                "Personal Information",
                style: TextStyle(
                  color: gold,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          "First Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      CustomTextfield(
                        value: auth.firstName,
                        onChange: (String value) {
                          authFunc.updateAuthState(firstName: value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          "Last Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      CustomTextfield(
                        value: auth.lastName,
                        onChange: (String value) {
                          authFunc.updateAuthState(lastName: value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12, top: 40),
              child: Text(
                "Father's Name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CustomTextfield(
              value: auth.fathersName,
              onChange: (String value) {
                authFunc.updateAuthState(fathersName: value);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            "Date of Birth",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DobSelectorField(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            "Gender",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DropdownBox(
                          items: const ["Male", "Female"],
                          onTap: (value) {
                            authFunc.updateAuthState(gender: value);
                          },
                          value: auth.gender,
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
    );
  }
}
