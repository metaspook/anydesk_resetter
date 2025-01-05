import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'resetter_state.dart';

class ResetterCubit extends Cubit<ResetterState> {
  ResetterCubit() : super(ResetterInitial());
}
