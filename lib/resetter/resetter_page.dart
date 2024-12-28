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
      appBar: AppBar(
        title: const Text(App.titleText),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${processInfo.name} is ${isProcessRunning ? 'running' : 'not running'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: checkProcess,
              //   child: const Text('Check Again'),
              // // ),
              // const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: resetAnyDesk,
                label: const Text('Reset ID/Ads'),
                icon: Icon(
                  iconRecord.iconData,
                  color: iconRecord.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
