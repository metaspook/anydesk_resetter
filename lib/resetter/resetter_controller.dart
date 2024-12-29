import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

class ResetterController extends ChangeNotifier {
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

//   static Stream<bool> monitorProcess2(
//     ProcessInfo process, {
//     Duration interval = const Duration(seconds: 1),
//   }) {
//     final timer = Timer.periodic(interval, (_){
//       _.
//  try {
//         final isRunning = isProcessRunning(process);
//         yield isRunning;
//       } on Exception catch (e) {
//         debugPrint('Error monitoring process ${process.name}: $e');
//         return false;
//       }
//     });
//     timer.

//     return Stream.periodic(interval, (_) {
//       try {
//         final isRunning = isProcessRunning(process);
//         return isRunning;
//       } on Exception catch (e) {
//         debugPrint('Error monitoring process ${process.name}: $e');
//         return false;
//       }
//     });
//   }
}

class ProcessInfo {
  const ProcessInfo({
    required this.name,
    required this.possibleNames,
  });
  final String name;
  final List<String> possibleNames;
}
