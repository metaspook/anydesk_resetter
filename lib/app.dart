import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/shared/repositories/process_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
          debugShowCheckedModeBanner: false,
          home: RepositoryProvider(
            create: (context) => ProcessRepo(App.processName),
            child: const ResetterPage(),
          ),
          theme: ThemeData(
            textTheme: GoogleFonts.kodeMonoTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // checkboxTheme: const CheckboxThemeData(
            // fillColor: WidgetStatePropertyAll(Colors.cyanAccent)),
            useMaterial3: true,
          ),
        );

  static const titleText = 'AnyDesk Resetter';
  static const processName = 'AnyDesk';
  static const author = 'Metaspook';
  static const version = 'v1.0.0';
  static const assetAnyDeskLogo = 'assets/anydesk_logo_1.png';
}
