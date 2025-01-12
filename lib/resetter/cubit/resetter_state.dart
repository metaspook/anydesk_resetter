part of 'resetter_cubit.dart';

enum ResetterStatus {
  initial,
  success,
  failure,
  loading,
  resetting;

  bool get isLoading => this == ResetterStatus.loading;
  bool get isResetting => this == ResetterStatus.resetting;
}

class ResetterState extends Equatable {
  const ResetterState({
    this.status = ResetterStatus.initial,
    this.anyDeskOnline = false,
    this.dataExists = false,
    this.keepFavoritesAndRecentSessions = true,
  });
  final ResetterStatus status;
  final bool anyDeskOnline;
  final bool dataExists;
  final bool keepFavoritesAndRecentSessions;

  ResetterState copyWith({
    ResetterStatus? status,
    bool? anyDeskOnline,
    bool? dataExists,
    bool? keepFavoritesAndRecentSessions,
  }) {
    return ResetterState(
      status: status ?? this.status,
      anyDeskOnline: anyDeskOnline ?? this.anyDeskOnline,
      dataExists: dataExists ?? this.dataExists,
      keepFavoritesAndRecentSessions:
          keepFavoritesAndRecentSessions ?? this.keepFavoritesAndRecentSessions,
    );
  }

  @override
  List<Object> get props => [
        status,
        anyDeskOnline,
        dataExists,
        keepFavoritesAndRecentSessions,
      ];
}
