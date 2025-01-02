import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetterPage extends StatefulWidget {
  const ResetterPage({super.key});

  @override
  State<ResetterPage> createState() => _ResetterPageState();
}

class _ResetterPageState extends State<ResetterPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final double _angle = 0;
  Timer? _timer;
  final double _turns = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ResetterController>;
    final isReset = Random().nextBool();
    final resetIconRecord = isReset
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
          padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                spacing: 2.5,
                children: [
                  Image.asset(
                    'assets/anydesk_logo_1.png',
                    scale: 2.5,
                  ),
                  Selector<ResetterController, bool>(
                    selector: (_, state) => state.isProcessRunning,
                    builder: (_, isProcessRunning, __) {
                      final processIconRecord = isProcessRunning
                          ? (color: Colors.green, iconData: Icons.sync_rounded)
                          : (
                              color: Colors.red,
                              iconData: Icons.sync_disabled_rounded
                            );
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 7.5,
                        children: [
                          // AnyDesk status text
                          Text(
                            isProcessRunning ? 'running' : 'not running',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Icon(
                            processIconRecord.iconData,
                            color: processIconRecord.color,
                            size: 24 * 1.115,
                          ),
                        ],
                      );
                    },
                  ),
                ],
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
                  resetIconRecord.iconData,
                  color: resetIconRecord.color,
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
              // const SizedBox(height: .75),
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
