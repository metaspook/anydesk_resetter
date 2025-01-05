part of 'resetter_cubit.dart';

sealed class ResetterState extends Equatable {
  const ResetterState();

  @override
  List<Object> get props => [];
}

final class ResetterInitial extends ResetterState {}
