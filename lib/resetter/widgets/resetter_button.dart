import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetterButton extends StatelessWidget {
  const ResetterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetterCubit>;
    final dataExists = context.select(
      (ResetterCubit cubit) => cubit.state.dataExists,
    );
    final isResetting = context.select(
      (ResetterCubit cubit) => cubit.state.status.isResetting,
    );
    final isResettingOrLoading = context.select(
      (ResetterCubit cubit) =>
          cubit.state.status.isLoading || cubit.state.status.isResetting,
    );

    return isResettingOrLoading
        ? ElevatedButton(
            onPressed: null,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(appSpacing),
            ),
          )
        : !isResetting && dataExists
            ? ElevatedButton.icon(
                onPressed: cubit().resetAnyDesk,
                label: const Text(
                  'Reset',
                  // until 1.6 maintains original size
                  textScaler: TextScaler.linear(1.6),
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  size: 27.5,
                  Icons.restart_alt_rounded,
                  color: Colors.cyanAccent,
                ),
              )
            : ElevatedButton(
                onPressed: null,
                child: Text(
                  'No data found to reset!',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              );
  }
}

// class ResetterButtonText extends StatelessWidget {
//   const ResetterButtonText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isNotLoadingAndDataNotExists = context.select(
//       (ResetterCubit cubit) =>
//           !cubit.state.dataExists && !cubit.state.status.isLoading,
//     );
//     final isLoading = context.select(
//       (ResetterCubit cubit) => cubit.state.status.isLoading,
//     );

//     return isNotLoadingAndDataNotExists
//         ? Text(
//             'No data found to reset!',
//             style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                   color: Colors.white,
//                 ),
//           )
//         : isLoading
//             ? const Text(
//                 'Reset',
//                 // until 1.6 maintains original size
//                 textScaler: TextScaler.linear(1.6),
//                 style: TextStyle(
//                   color: Colors.yellow,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             : Text(
//                 'No data found to reset!',
//                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                       color: Colors.white,
//                     ),
//               );
//   }
// }

// class ResetterButtonIcon extends StatelessWidget {
//   const ResetterButtonIcon({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isLoadingOrDataNotExists = context.select(
//       (ResetterCubit cubit) =>
//           !cubit.state.dataExists || cubit.state.status.isLoading,
//     );
//     return isLoadingOrDataNotExists
//         ? const SizedBox.shrink()
//         : const Icon(
//             size: 27.5,
//             Icons.restart_alt_rounded,
//             color: Colors.cyanAccent,
//           );
//   }
// }
