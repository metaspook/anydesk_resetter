import 'dart:io';

import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class ProcessRepo {
  ProcessRepo(this.processName) : logger = Logger('ProcessRepo');
  final String processName;
  final Logger logger;

  Stream<bool> monitorProcess(
    String name, {
    Duration interval = const Duration(seconds: 1),
  }) =>
      Stream.periodic(interval, (_) {
        try {
          return processRunningTaskStdOut(name).contains(name);
        } on Exception catch (e, s) {
          logger.severe('Error monitoring process: $name', e, s);
          return false;
        }
      });

  String processRunningTaskStdOut(String name) {
    final taskRecord = existenceTaskRecord(name);
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
    return stdout;
  }

  bool killProcess() {
    final stdOut = processRunningTaskStdOut(processName);
    print('stdOut: $stdOut');
    // return stdOut;
    final taskRecord = terminationTaskRecord(processName);
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
    return true;
  }

  Future<bool> reset({bool keepData = true}) async {
    killProcess();
    // path list parser
    List<String> parsePaths(List<List<String>> pathsList) => [
          for (final e in pathsList)
            if (keepData) ...[
              [...e, 'service.conf'].joinAsPath(),
              [...e, 'system.conf'].joinAsPath(),
            ] else
              e.joinAsPath(),
        ];
    // path list preparation
    final paths = switch (Platform.operatingSystem) {
      Platforms.windows => parsePaths(
          [
            ['${Platform.environment['APPDATA']}', 'AnyDesk'],
            ['${Platform.environment['PROGRAMDATA']}', 'AnyDesk'],
          ],
        ),
      Platforms.linux => parsePaths(
          [
            ['etc', 'anydesk'],
            ['${Platform.environment['HOME']}', '.anydesk'],
          ],
        ),
      Platforms.macos => parsePaths(
          [
            ['Library', 'Application Support', 'AnyDesk'],
            [
              '${Platform.environment['HOME']}',
              'Library',
              'Application Support',
              'AnyDesk',
            ]
          ],
        ),
      _ => throw PlatformException(
          code: ErrorCodes.unsupportedPlatform,
          message: '${Platform.operatingSystem} not supported',
        ),
    };
    // path delete helper
    Future<bool> deletePath(String path) async {
      final entity = keepData ? File(path) : Directory(path);
      try {
        if (await entity.exists()) {
          await entity.delete(recursive: true);
          logger.severe('Deleted ${entity.runtimeType}: ${entity.path}');
          return true;
        }
      } on FileSystemException catch (e) {
        logger.severe('Failed to delete ${entity.path}: ${e.message}');
      }
      return false;
    }

    // reset operation
    try {
      return (await Future.wait(paths.map(deletePath))).contains(true);
    } on Exception catch (e) {
      logger.severe('Error resetting AnyDesk data: $e');
    }
    return false;
  }
}
