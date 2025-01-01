import 'dart:io';
import 'dart:math';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetterPage extends StatelessWidget {
  const ResetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ResetterController>;
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
              // AnyDesk status text
              Selector<ResetterController, bool>(
                selector: (_, state) => state.isProcessRunning,
                builder: (_, isProcessRunning, __) => Text(
                  '${controller().processName}: ${isProcessRunning ? 'running' : 'not running'}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              // Reset Button
              ElevatedButton.icon(
                onPressed: () {
                  // Process.runSync(executable, arguments)
                  const name = 'AnyDesk';
                  final taskRecord = getTaskRecord(name);
                  // debugPrint('selfName: $selfName');
                  final result = Process.runSync(
                    taskRecord.executable,
                    taskRecord.arguments,
                    runInShell: true,
                  );
                  debugPrint('stdout: ${result.stdout}');
                  debugPrint('stderr: ${result.stderr}');
                },
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
