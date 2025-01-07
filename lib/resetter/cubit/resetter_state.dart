part of 'resetter_cubit.dart';

enum ResetterStatus {
  initial,
  success,
  failure,
  loading;

  bool get isLoading => this == ResetterStatus.loading;
}

class ResetterState extends Equatable {
  const ResetterState({
    this.status = ResetterStatus.initial,
    this.anyDeskOnline = false,
    this.keepFavoritesAndRecentSessions = true,
  });
  final ResetterStatus status;
  final bool anyDeskOnline;
  final bool keepFavoritesAndRecentSessions;

  ResetterState copyWith({
    ResetterStatus? status,
    bool? anyDeskOnline,
    bool? keepFavoritesAndRecentSessions,
  }) {
    return ResetterState(
      status: status ?? this.status,
      anyDeskOnline: anyDeskOnline ?? this.anyDeskOnline,
      keepFavoritesAndRecentSessions:
          keepFavoritesAndRecentSessions ?? this.keepFavoritesAndRecentSessions,
    );
  }

  @override
  List<Object> get props =>
      [status, anyDeskOnline, keepFavoritesAndRecentSessions];
}
