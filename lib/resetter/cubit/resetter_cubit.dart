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
    var prevStatus = state.status;
    emit(
      state.copyWith(
        status: ResetterStatus.loading,
        keepFavoritesAndRecentSessions: !state.keepFavoritesAndRecentSessions,
      ),
    );
    await _monitorDataSubscription?.cancel();
    _monitorDataSubscription = _processRepo
        .monitorData(keepData: state.keepFavoritesAndRecentSessions)
        .listen((dataExists) {
      emit(state.copyWith(status: prevStatus, dataExists: dataExists));
      prevStatus = state.status;
    });
  }

  Future<void> resetAnyDesk() async {
    emit(state.copyWith(status: ResetterStatus.resetting));
    final success = await _processRepo.reset(
      keepData: state.keepFavoritesAndRecentSessions,
    );
    // delay is important to prevent showing reset button before no data text.
    await Future<void>.delayed(const Duration(milliseconds: 2500), () {
      emit(
        success
            ? state.copyWith(status: ResetterStatus.success)
            : state.copyWith(status: ResetterStatus.failure),
      );
    });
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
