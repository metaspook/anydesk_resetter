import 'dart:io';
import 'dart:math';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.withValues(alpha: 10),
                  Colors.white.withValues(alpha: 90),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Resets ID/Ads',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          'Developed by, Metaspook',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${processInfo.name}: ${isProcessRunning ? 'running' : 'not running'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: resetAnyDesk,
                  label: const Text('Reset ID/Ads'),
                  icon: Icon(
                    iconRecord.iconData,
                    color: iconRecord.color,
                  ),
                ),
                // const Spacer(),
                Column(
                  children: [
                    Text(
                      'NOTE: This app is NOT encourages any kind of illegal '
                      'user of ${App.name} rather educational or experimental '
                      'perpose only.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 7.5),
                    Text(
                      'Copyright (c) 2024 Metaspook',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
