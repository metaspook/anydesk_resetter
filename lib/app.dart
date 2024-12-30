import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
          debugShowCheckedModeBanner: false,
          home: const ResetterPage(),
          title: titleText,
          theme: ThemeData(
            textTheme: GoogleFonts.kodeMonoTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );

  static const titleText = 'AnyDesk Resetter';
  static const name = 'AnyDesk';
}
