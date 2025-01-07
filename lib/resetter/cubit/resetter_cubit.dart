import 'dart:async';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/shared/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'resetter_state.dart';

class ResetterCubit extends Cubit<ResetterState> {
  ResetterCubit({
    required ProcessRepo processRepo,
  })  : _processRepo = processRepo,
        super(const ResetterState()) {
    //-- Subscribe to monitorProcess stream.
    _processRunningSubscription = _processRepo
        .monitorProcess(App.processName)
        .listen(_changeProcessRunning);
  }

  final ProcessRepo _processRepo;
  StreamSubscription<bool>? _processRunningSubscription;

  //-- Cubit Methods
  void changeKeepFavoritesAndRecentSessions() {
    emit(
      state.copyWith(
        keepFavoritesAndRecentSessions: !state.keepFavoritesAndRecentSessions,
      ),
    );
  }

  Future<void> resetAnyDesk({bool keepData = true}) async {
    emit(state.copyWith(status: ResetterStatus.loading));
    final success = await _processRepo.reset(keepData: keepData);
    emit(
      success
          ? state.copyWith(status: ResetterStatus.success)
          : state.copyWith(status: ResetterStatus.failure),
    );
  }

  //-- Private helpers
  void _changeProcessRunning(bool value) {
    emit(state.copyWith(anyDeskOnline: value));
  }

  @override
  Future<void> close() {
    _processRunningSubscription?.cancel();
    return super.close();
  }
}
