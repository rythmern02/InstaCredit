import 'dart:io';

import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/design/dropdown.dart';
import 'package:bnpl_flutter/design/textfield.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentUpload extends ConsumerStatefulWidget {
  const DocumentUpload({super.key});

  @override
  ConsumerState<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends ConsumerState<DocumentUpload> {
  bool _docUploaded = false;
  bool _panUploaded = false;

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
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Choose Documents",
                style: TextStyle(
                  color: gold,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12, top: 20),
              child: Text(
                "Name of Document",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            DropdownBox(
              items: const ["Aadhar Card", "Driving License"],
              onTap: (value) {
                authFunc.updateAuthState(idDoc: value);
              },
              value: auth.idDoc,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12, top: 20),
              child: Text(
                "Enter the Identity Number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CustomTextfield(
              value: auth.idNumber,
              onChange: (value) {
                authFunc.updateAuthState(idNumber: value);
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.image,
                    );
                    if (result != null) {
                      authFunc.updateAuthState(
                        idDocFile: File(result.files.single.path!),
                      );
                      setState(() {
                        _docUploaded = true;
                      });
                    } else {
                      setState(() {
                        _docUploaded = false;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    fixedSize: Size.fromWidth(deviceWidth(context) * 0.75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                      side: const BorderSide(
                        color: gold,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Upload Image",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: gold,
                        ),
                      ),
                      if (_docUploaded)
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: gold,
                        )
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12, top: 20),
              child: Text(
                "Enter your PAN Number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CustomTextfield(
              value: auth.panNumber,
              onChange: (value) {
                authFunc.updateAuthState(panNumber: value);
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.image,
                    );
                    if (result != null) {
                      authFunc.updateAuthState(
                        panDocFile: File(result.files.single.path!),
                      );
                      setState(() {
                        _panUploaded = true;
                      });
                    } else {
                      setState(() {
                        _panUploaded = false;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    fixedSize: Size.fromWidth(deviceWidth(context) * 0.75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                      side: const BorderSide(
                        color: gold,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Upload PAN",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: gold,
                        ),
                      ),
                      if (_panUploaded)
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: gold,
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
