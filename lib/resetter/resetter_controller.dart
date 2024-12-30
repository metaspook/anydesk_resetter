import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ResetterController extends ChangeNotifier {
  ResetterController(ProcessInfo processInfo) : _processInfo = processInfo;

  final ProcessInfo _processInfo;

  final bool _isProcessRunning = false;

  bool _checkWindowsProcess() {
    final success = Process.runSync(
      'tasklist',
      ['/FI', 'IMAGENAME eq ${_processInfo.name}.exe'],
    ).stdout.toString().contains(_processInfo.name);
    return success
        ? success
        : Process.runSync(
            'tasklist',
            ['/FI', 'WINDOWTITLE eq ${_processInfo.name}'],
          ).stdout.toString().contains(_processInfo.name);
  }

  bool _checkUnixProcess() {
// The `-e` flag is the POSIX standard and works consistently across
// Unix-like systems, making it more reliable than
// platform-specific flags like `-A` or `-ax`.
    final result = Process.runSync('ps', ['-e']);
    return _processInfo.possibleNames
        .any(result.stdout.toString().toLowerCase().contains);
  }

  bool isProcessRunning() {
    try {
      if (Platform.isWindows) {
        return _checkWindowsProcess();
      } else if (Platform.isLinux || Platform.isMacOS) {
        return _checkUnixProcess();
      }
      return false;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Stream<bool> monitorProcess(
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
}

class ProcessInfo {
  const ProcessInfo({
    required this.name,
    required this.possibleNames,
  });
  final String name;
  final List<String> possibleNames;
}
