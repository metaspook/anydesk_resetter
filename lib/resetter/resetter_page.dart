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
  bool isProcessRunning = false;
  final processInfo = const ProcessInfo(
    name: 'AnyDesk',
    possibleNames: ['anydesk', 'AnyDesk*'],
  );

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

  void resetAnyDesk() {
    debugPrint('reset button pressed!');
    if (!isProcessRunning) {
      debugPrint('${processInfo.name} is not running');
      return;
    }

    try {
      ProcessResult forceResult;

      if (Platform.isWindows) {
        forceResult = Process.runSync(
          'taskkill',
          ['/F', '/FI', 'WINDOWTITLE eq ${processInfo.name}'],
        );
      } else if (Platform.isMacOS || Platform.isLinux) {
        // killall command works on both MacOS and Linux
        forceResult = Process.runSync(
          'killall',
          ['-9', processInfo.name],
        );
      } else {
        throw PlatformException(
          code: 'UNSUPPORTED_PLATFORM',
          message: 'Platform not supported',
        );
      }

      debugPrint(
        forceResult.exitCode == 0
            ? 'Successfully terminated ${processInfo.name}'
            : 'Failed to terminate ${processInfo.name}: ${forceResult.stderr}',
      );
    } on ProcessException catch (e) {
      debugPrint('Error terminating process: $e');
    } on PlatformException catch (e) {
      debugPrint('Platform error: ${e.message}');
    }
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
              // const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: resetAnyDesk,
                label: const Text(
                  'Reset ID/Ads',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  iconRecord.iconData,
                  color: iconRecord.color,
                ),
                style: ElevatedButton.styleFrom(
                  // textStyle: const TextStyle(
                  //   color: Colors.cyanAccent,
                  // ),
                  backgroundColor: Colors.white.withValues(alpha: 75),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
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
