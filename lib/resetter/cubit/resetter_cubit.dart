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
        .monitorProcess(name: App.processName)
        .listen(_changeAnyDeskOnline);
    //-- Subscribe to monitorData stream.
    _monitorDataSubscription = _processRepo
        .monitorData(keepData: state.keepFavoritesAndRecentSessions)
        .listen(_changeDataExists);
  }

  final ProcessRepo _processRepo;
  StreamSubscription<bool>? _monitorDataSubscription;
  StreamSubscription<bool>? _processRunningSubscription;

  //-- Cubit Methods
  Future<void> changeKeepFavoritesAndRecentSessions() async {
    final prevStatus = state.status;
    emit(state.copyWith(status: ResetterStatus.loading));
    await _monitorDataSubscription?.cancel();
    // await Future<void>.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        status: prevStatus,
        keepFavoritesAndRecentSessions: !state.keepFavoritesAndRecentSessions,
      ),
    );
    _monitorDataSubscription = _processRepo
        .monitorData(keepData: state.keepFavoritesAndRecentSessions)
        .listen(_changeDataExists);
  }

  Future<void> resetAnyDesk() async {
    emit(state.copyWith(status: ResetterStatus.loading, isResetting: true));
    final success = await _processRepo.reset(
      keepData: state.keepFavoritesAndRecentSessions,
    );
    emit(
      success
          ? state.copyWith(status: ResetterStatus.success, isResetting: false)
          : state.copyWith(status: ResetterStatus.failure, isResetting: false),
    );
  }

  //-- Private helpers
  void _changeAnyDeskOnline(bool value) {
    emit(state.copyWith(anyDeskOnline: value));
  }

  void _changeDataExists(bool value) {
    emit(state.copyWith(dataExists: value));
  }

  @override
  Future<void> close() {
    _processRunningSubscription?.cancel();
    _monitorDataSubscription?.cancel();
    return super.close();
  }
}
