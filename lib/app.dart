import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/shared/repositories/process_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
          // title: 'ds    AnyDesk Resetter',
          debugShowCheckedModeBanner: false,
          home: RepositoryProvider(
            create: (context) => ProcessRepo(App.processName),
            child: const ResetterPage(),
          ),
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.kodeMonoTextTheme(),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              linearTrackColor: Colors.black.withValues(alpha: 150),
              color: Colors.cyanAccent,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 150),
              ),
            ),
            checkboxTheme: CheckboxThemeData(
              checkColor: const WidgetStatePropertyAll(Colors.yellow),
              side: BorderSide(
                color: Colors.black.withValues(alpha: 150),
                width: 2,
              ),
              fillColor: WidgetStateColor.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.black.withValues(alpha: 150)
                    : Colors.transparent,
              ),
            ),
          ),
        );

  static const titleText = 'AnyDesk Resetter';
  static const processName = 'AnyDesk';
  static const author = 'Metaspook';
  static const version = 'v1.0.0';
  static const assetAnyDeskLogo = 'assets/anydesk_logo_1.png';
}
