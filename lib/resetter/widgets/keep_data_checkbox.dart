import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeepDataCheckbox extends StatelessWidget {
  const KeepDataCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetterCubit>;
    final isResetting =
        context.select((ResetterCubit cubit) => cubit.state.status.isResetting);
    final isResettingOrLoading =
        context.select((ResetterCubit cubit) => cubit.state.status.isLoading) ||
            isResetting;
    final keepFavoritesAndRecentSessions = context.select(
      (ResetterCubit cubit) => cubit.state.keepFavoritesAndRecentSessions,
    );
    return Row(
      children: [
        Checkbox(
          tristate: true,
          value: isResettingOrLoading ? null : keepFavoritesAndRecentSessions,
          onChanged: isResettingOrLoading
              ? null
              : (_) => cubit().changeKeepFavoritesAndRecentSessions(),
        ),
        Text(
          isResetting
              ? 'Wait! data resetting on progress'
              : 'Keep Favorites & Recent Sessions',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
