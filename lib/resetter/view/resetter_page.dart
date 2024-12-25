import 'dart:io';

import 'package:anydesk_resetter/app.dart';
import 'package:flutter/material.dart';

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
    ProcessUtils.monitorProcess(processInfo).listen((running) {
      setState(() {
        isProcessRunning = running;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(App.titleText),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${processInfo.name} is ${isProcessRunning ? 'running' : 'not running'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: checkProcess,
              child: const Text('Check Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessInfo {
  const ProcessInfo({
    required this.name,
    required this.possibleNames,
  });
  final String name;
  final List<String> possibleNames;
}

class ProcessUtils {
  static bool _checkWindowsProcess(ProcessInfo process) {
    final success = Process.runSync(
      'tasklist',
      ['/FI', 'IMAGENAME eq ${process.name}.exe'],
    ).stdout.toString().contains(process.name);
    return success
        ? success
        : Process.runSync(
            'tasklist',
            ['/FI', 'WINDOWTITLE eq ${process.name}'],
          ).stdout.toString().contains(process.name);
  }

  static bool _checkUnixProcess(ProcessInfo process) {
// The `-e` flag is the POSIX standard and works consistently across
// Unix-like systems, making it more reliable than
// platform-specific flags like `-A` or `-ax`.
    final result = Process.runSync('ps', ['-e']);
    return process.possibleNames
        .any(result.stdout.toString().toLowerCase().contains);
  }

  static bool isProcessRunning(ProcessInfo process) {
    try {
      if (Platform.isWindows) {
        return _checkWindowsProcess(process);
      } else if (Platform.isLinux || Platform.isMacOS) {
        return _checkUnixProcess(process);
      }
      return false;
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Stream<bool> monitorProcess(
    ProcessInfo process, {
    Duration interval = const Duration(seconds: 1),
  }) =>
      Stream.periodic(interval, (_) {
        try {
          final isRunning = isProcessRunning(process);
          return isRunning;
        } on Exception catch (e) {
          debugPrint('Error monitoring process ${process.name}: $e');
          return false;
        }
      });
}
