import 'package:bnpl_flutter/constants.dart';
import 'package:bnpl_flutter/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            background: backgroundBlack,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const AuthScreen(),
      ),
    ),
  );
}
