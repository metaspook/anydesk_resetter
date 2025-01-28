import 'dart:io';
import 'dart:math' as math;

import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class ProcessRepo {
  ProcessRepo(this.processName);
  final String processName;
  final _logger = Logger('ProcessRepo');
  static const _minInterval = Duration(seconds: 1);
  Duration _currentIntervalProcess = _minInterval;
  Duration _currentIntervalData = _minInterval;

  Stream<bool> monitorProcess({
    required String name,
    int maxIntervalSeconds = 10,
  }) async* {
    final maxInterval = Duration(seconds: maxIntervalSeconds);
    while (true) {
      final result = await Future.delayed(_currentIntervalProcess, () async {
        try {
          return (await runningTaskStdout(name)).contains(name);
        } on Exception catch (e, s) {
          _logger.severe('Error monitoring process: $name', e, s);
          return false;
        }
      });
      yield result;
      _currentIntervalProcess = _adaptInterval(maxInterval, result: result);
    }
  }

  Stream<bool> monitorData({
    required bool keepData,
    int maxIntervalSeconds = 5,
  }) async* {
    final maxInterval = Duration(seconds: maxIntervalSeconds);
    while (true) {
      final result = await Future.delayed(_currentIntervalData, () async {
        try {
          return dataExists(keepData: keepData);
        } on Exception catch (e, s) {
          _logger.severe('Error monitoring data!', e, s);
          return false;
        }
      });
      yield result;
      _currentIntervalData = _adaptInterval(maxInterval, result: result);
    }
  }

  Future<String> runningTaskStdout(String name) async {
    final taskRecord = existenceTaskRecord(name);
    final result = await Process.run(
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

  Future<bool> killProcess() async {
    final stdOut = (await runningTaskStdout(processName)).contains(processName);
    // i. returns false if process isn't running.
    if (!stdOut) return false;
    final taskRecord = terminationTaskRecord(processName);
    final result = await Process.run(
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

  Future<bool> dataExists({required bool keepData}) async {
    // i. path list parser
    List<String> parsePaths(List<List<String>> pathsList) => [
          for (final e in pathsList)
            if (keepData) ...[
              [...e, 'service.conf'].joinAsPath(),
              [...e, 'system.conf'].joinAsPath(),
            ] else
              e.joinAsPath(),
        ];
    // i. path list preparation
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
    // i. find operation
    try {
      return [
        for (final path in paths)
          await (keepData ? File(path) : Directory(path)).exists(),
      ].contains(true);
    } on Exception catch (e) {
      _logger.severe('Error finding AnyDesk data: $e');
    }
    return false;
  }

  Future<bool> reset({required bool keepData}) async {
    // i. kill the process if running
    await killProcess();
    // i. path list parser
    List<String> parsePaths(List<List<String>> pathsList) => [
          for (final e in pathsList)
            if (keepData) ...[
              [...e, 'service.conf'].joinAsPath(),
              [...e, 'system.conf'].joinAsPath(),
            ] else
              e.joinAsPath(),
        ];
    // i. path list preparation
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
    // i. path delete helper
    Future<bool> deletePath(String path) async {
      final entity = keepData ? File(path) : Directory(path);
      try {
        if (await entity.exists()) {
          await entity.delete(recursive: true);
          _logger.severe('Deleted ${entity.runtimeType}: ${entity.path}');
          return true;
        }
      } on FileSystemException catch (e) {
        _logger.severe('Failed to delete ${entity.path}: ${e.message}');
      }
      return false;
    }

    // i. reset operation
    try {
      return (await Future.wait(paths.map(deletePath))).contains(true);
    } on Exception catch (e) {
      _logger.severe('Error resetting AnyDesk data: $e');
    }
    return false;
  }

  //-- Private helpers
  // i. running - adapt interval by increase to reduce CPU load
  // i. not running - adapt interval by decrease for faster updates
  Duration _adaptInterval(Duration maxInterval, {required bool result}) =>
      Duration(
        seconds: result
            ? math.min(
                _currentIntervalData.inSeconds * 2,
                maxInterval.inSeconds,
              )
            : math.max(
                _currentIntervalData.inSeconds ~/ 2,
                _minInterval.inSeconds,
              ),
      );
}
