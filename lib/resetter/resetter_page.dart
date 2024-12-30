import 'dart:io';
import 'dart:math';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetterPage extends StatefulWidget {
  const ResetterPage({super.key});

  @override
  State<ResetterPage> createState() => _ResetterPageState();
}

class _ResetterPageState extends State<ResetterPage> {
  @override
  void initState() {
    super.initState();
    checkProcess();
  }

  Future<void> checkProcess() async {
    ResetterController.monitorProcess(processInfo).listen((running) {
      setState(() {
        isProcessRunning = running;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReset = Random().nextBool();
    final iconRecord = isReset
        ? (color: Colors.green, iconData: Icons.check_circle_outline_rounded)
        : (color: Colors.red, iconData: Icons.restart_alt_rounded);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 75),
              Colors.grey.withValues(alpha: 25),
              Colors.white.withValues(alpha: 25),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resets ID/Ads',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.cyanAccent,
                            ),
                      ),
                      Text(
                        'Developed by, Metaspook',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.cyanAccent,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${processInfo.name}: ${isProcessRunning ? 'running' : 'not running'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              // Reset Button
              ElevatedButton.icon(
                onPressed: resetAnyDesk,
                label: const Text(
                  'Reset',
                  textScaler: TextScaler.linear(1.75),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  size: 27.5,
                  iconRecord.iconData,
                  color: iconRecord.color,
                  applyTextScaling: true,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10.75,
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 75),
                ),
              ),
              const SizedBox(height: .75),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'NOTE: ',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text:
                              'This app is NOT encourages any kind of illegal usages of ${App.name}, rather educational or experimental perpose only.',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.kodeMono(),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Copyright (c) 2024 Metaspook',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
