import 'dart:async';
import 'dart:io';

import 'package:anydesk_resetter/repositories/process_repo.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ResetterController extends ChangeNotifier {
  ResetterController({
    required this.processName,
    required ProcessRepo processRepo,
  }) : _processRepo = processRepo {
    _processRunningSubscription =
        _processRepo.monitorProcess(processName).listen(_changeProcessRunning);
  }

  final ProcessRepo _processRepo;
  StreamSubscription<bool>? _processRunningSubscription;
  final String processName;
  //-- Initial State
  bool _isProcessRunning = false;
  double _turns = 5;
  bool _keepFavoritesAndRecentSessions = true;

  //-- Current State getters
  bool get isProcessRunning => _isProcessRunning;
  double get turns => _turns;
  bool get keepFavoritesAndRecentSessions => _keepFavoritesAndRecentSessions;

  //-- Updated State setters
  void changeKeepFavoritesAndRecentSessions() {
    _keepFavoritesAndRecentSessions = !_keepFavoritesAndRecentSessions;
    notifyListeners();
  }

  void incrementsTurns() {
    print('object: $_turns');
    _turns = 5;
    notifyListeners();
  }

  void terminateProcess() {
    _processRepo.killProcess(processName);
  }

  List<String> parsePaths(
    List<List<String>> pathsList, {
    bool keepData = true,
  }) =>
      [
        for (final e in pathsList)
          if (keepData) ...[
            [...e, 'service.conf'].joinAsPath(),
            [...e, 'system.conf'].joinAsPath(),
          ] else
            e.joinAsPath(),
      ];

  Future<bool> resetAnyDeskData({bool keepData = true}) async {
    try {
      // if exist "%%X\service.conf" del /f /q "%%X\service.conf"
      // if exist "%%X\system.conf" del /f /q "%%X\system.conf"
      final paths = switch (Platform.operatingSystem) {
        Platforms.windows => parsePaths(
            [
              ['${Platform.environment['APPDATA']}', 'AnyDesk'],
              ['${Platform.environment['PROGRAMDATA']}', 'AnyDesk'],
            ],
            keepData: keepData,
          ),
        Platforms.linux => parsePaths(
            [
              ['etc', 'anydesk'],
              ['${Platform.environment['HOME']}', '.anydesk'],
            ],
            keepData: keepData,
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
            keepData: keepData,
          ),
        _ => throw PlatformException(
            code: ErrorCodes.unsupportedPlatform,
            message: '${Platform.operatingSystem} not supported',
          ),
      };

      for (final path in paths) {
        if (keepData) {
          final file = File(path);
          if (file.existsSync()) {
            await file.delete(recursive: true);
            debugPrint('Deleted: $path');
          }
        } else {
          final directory = Directory(path);
          if (directory.existsSync()) {
            await directory.delete(recursive: true);
            debugPrint('Deleted: $path');
          }
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error resetting AnyDesk data: $e');
      return false;
    }
  }

  //-- Private helpers
  // ignore: avoid_positional_boolean_parameters
  void _changeProcessRunning(bool value) {
    _isProcessRunning = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _processRunningSubscription?.cancel();
    super.dispose();
  }
}
