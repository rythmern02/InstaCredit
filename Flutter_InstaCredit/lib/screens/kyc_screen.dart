// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bnpl_flutter/components/contact_info.dart';
import 'package:bnpl_flutter/components/document_upload.dart';
import 'package:bnpl_flutter/components/personal_info.dart';
import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/design/pageview_indicator.dart';
import 'package:bnpl_flutter/riverpod/auth_state.dart';
import 'package:bnpl_flutter/screens/profile_complete.dart';
import 'package:bnpl_flutter/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.toInt();
      });
    });
  }
}
