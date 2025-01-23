import 'dart:developer' as dev;
import 'dart:io';

import 'package:anydesk_resetter/shared/models/models.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// Returns platform-specific command and arguments for process lookup.
/// * Windows: Uses tasklist with findstr.
/// * Unix/Mac: Uses ps with grep.
/// * Throws [PlatformException] for unsupported platforms.
TaskRecord existenceTaskRecord(String name) =>
    switch (Platform.operatingSystem) {
      Platforms.windows => (
          executable: 'tasklist',
          arguments: [
            '/NH',
            '/FI',
            'IMAGENAME eq $name*',
            '|',
            'findstr',
            '/V',
            '/I',
            Platform.executable,
          ],
        ),
      // i. flag `-e` is the POSIX alternative of `-A` or `-ax`.
      Platforms.macos || Platforms.linux => (
          executable: 'ps',
          arguments: [
            '-e',
            '|',
            'grep',
            '-i',
            name,
            '|',
            'grep',
            '-v',
            Platform.executable,
          ],
        ),
      _ => throw PlatformException(
          code: ErrorCodes.unsupportedPlatform,
          message: 'Platform: ${Platform.operatingSystem} is not supported!',
        ),
    };

TaskRecord terminationTaskRecord(String name) =>
    switch (Platform.operatingSystem) {
      Platforms.windows => (
          executable: 'taskkill',
          arguments: [
            '/F',
            '/FI',
            'IMAGENAME ne ${Platform.executable}',
            '/IM',
            '$name*',
          ],
        ),
      // i. flag `-e` is the POSIX alternative of `-A` Platform.executablePlatform.executableor `-ax`.
      Platforms.macos || Platforms.linux => (
          executable: 'pkill',
          arguments: [
            '-9', // Force kill
            '-f', // Full command line
            '-i', // Case insensitive
            '^(?!.*${Platform.executable}).*$name.*\$', // Regex pattern
          ],
        ),
      _ => throw PlatformException(
          code: ErrorCodes.unsupportedPlatform,
          message: 'Platform: ${Platform.operatingSystem} is not supported!',
        ),
    };

void devLog(LogRecord record) {
  if (debugMode) {
    dev.log(
      record.message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }
}
