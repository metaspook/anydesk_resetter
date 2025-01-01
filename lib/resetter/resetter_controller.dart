import 'dart:async';

import 'package:anydesk_resetter/repositories/process_repo.dart';
import 'package:flutter/foundation.dart';

class ResetterController extends ChangeNotifier {
  ResetterController({
    required this.processName,
    required ProcessRepo processRepo,
  }) : _processRepo = processRepo {
    _processRunningSubscription =
        _processRepo.monitorProcess(processName).listen(_setProcessRunning);
  }

  final ProcessRepo _processRepo;
  StreamSubscription<bool>? _processRunningSubscription;
  final String processName;
  // State of isProcessRunning
  bool _isProcessRunning = false;
  bool get isProcessRunning => _isProcessRunning;

  //-- Private helpers
  // ignore: avoid_positional_boolean_parameters
  void _setProcessRunning(bool value) {
    _isProcessRunning = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _processRunningSubscription?.cancel();
    super.dispose();
  }
}
