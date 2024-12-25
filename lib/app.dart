import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';

class App extends MaterialApp {
  App({super.key})
      : super(
          home: const ResetterPage(),
          title: titleText,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );

  static const titleText = 'AnyDesk Resetter';
}
