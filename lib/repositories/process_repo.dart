import 'dart:developer' as dev;
import 'dart:io';

import 'package:anydesk_resetter/utils/utils.dart';

class ProcessRepo {
  Stream<bool> monitorProcess(
    String name, {
    Duration interval = const Duration(seconds: 1),
  }) =>
      Stream.periodic(interval, (_) {
        try {
          return isProcessRunning(name);
        } on Exception catch (e, s) {
          dev.log('Error monitoring process: $name', error: e, stackTrace: s);
          return false;
        }
      });

  bool isProcessRunning(String name) {
    final taskRecord = getTaskRecord(name);
    final result = Process.runSync(
      taskRecord.executable,
      taskRecord.arguments,
      runInShell: true,
    );
    final (stdout, stderr) =
        (result.stdout.toString(), result.stderr.toString());
    if (stderr.isNotEmpty) {
      throw ProcessException(
        taskRecord.executable,
        taskRecord.arguments,
        stderr,
        result.exitCode,
      );
    }
    return stdout.contains(name);
  }

  // void resetAnyDesk() {
  //   debugPrint('reset button pressed!');
  //   if (!isProcessRunning) {
  //     debugPrint('${processInfo.name} is not running');
  //     return;
  //   }

  //   try {
  //     ProcessResult forceResult;
  //     if (Platform.isWindows) {
  //       forceResult = Process.runSync(
  //         'taskkill',
  //         ['/F', '/FI', 'WINDOWTITLE eq ${processInfo.name}'],
  //       );
  //     } else if (Platform.isMacOS || Platform.isLinux) {
  //       // killall command works on both MacOS and Linux
  //       forceResult = Process.runSync(
  //         'killall',
  //         ['-9', processInfo.name],
  //       );
  //     } else {
  //       throw PlatformException(
  //         code: 'UNSUPPORTED_PLATFORM',
  //         message: 'Platform not supported',
  //       );
  //     }

  //     debugPrint(
  //       forceResult.exitCode == 0
  //           ? 'Successfully terminated ${processInfo.name}'
  //           : 'Failed to terminate ${processInfo.name}: ${forceResult.stderr}',
  //     );
  //   } on ProcessException catch (e) {
  //     debugPrint('Error terminating process: $e');
  //   } on PlatformException catch (e) {
  //     debugPrint('Platform error: ${e.message}');
  //   }
  // }

  //-- Private helpers
}
