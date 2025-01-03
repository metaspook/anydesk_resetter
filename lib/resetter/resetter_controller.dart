import 'dart:async';

import 'package:anydesk_resetter/repositories/process_repo.dart';
import 'package:flutter/foundation.dart';

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

  //-- Current State getters
  bool get isProcessRunning => _isProcessRunning;
  double get turns => _turns;

  //-- Updated State setters
  void incrementsTurns() {
    print('object: $_turns');
    _turns = 5;
    notifyListeners();
  }

  void terminateProcess() {
    _processRepo.killProcess(processName);
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
