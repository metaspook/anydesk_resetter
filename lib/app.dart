import 'package:anydesk_resetter/repositories/process_repo.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
          debugShowCheckedModeBanner: false,
          home: MultiProvider(
            providers: [
              Provider<ProcessRepo>(create: (_) => ProcessRepo()),
              ChangeNotifierProvider<ResetterController>(
                create: (context) => ResetterController(
                  processName: 'AnyDesk',
                  processRepo: context.read<ProcessRepo>(),
                ),
              ),
            ],
            child: const ResetterPage(),
          ),
          title: titleText,
          theme: ThemeData(
            textTheme: GoogleFonts.kodeMonoTextTheme(),
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );

  static const titleText = 'AnyDesk Resetter';
  static const name = 'AnyDesk';
  static const assetAnyDeskLogo = 'assets/anydesk_logo_1.png';
}
