import 'package:anydesk_resetter/resetter/resetter.dart';
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
    final isLoading = context.select(
      (ResetterCubit cubit) => cubit.state.status.isLoading,
    );
    final isResetting = context.select(
      (ResetterCubit cubit) => cubit.state.isResetting,
    );

    // final isReset = Random().nextBool();
    // final resetIconRecord = isReset
    //     ? (color: Colors.green, iconData: Icons.check_circle_outline_rounded)
    //     : (color: Colors.red, iconData: Icons.restart_alt_rounded);

//  if (isLoading)
//                                   ElevatedButton(
//                                     onPressed: null,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Colors.black.withValues(alpha: 150),
//                                     ),
//                                     child: LinearProgressIndicator(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   )
//                                 else if (!dataExists)
//                                   ElevatedButton(
//                                     onPressed: null,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Colors.black.withValues(alpha: 150),
//                                     ),
//                                     child: Text(
//                                       'No data found to reset!',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .labelSmall
//                                           ?.copyWith(
//                                             color: Colors.white,
//                                           ),
//                                     ),
//                                   )
//                                 else
//                                   ElevatedButton.icon(
//                                     onPressed: cubit().resetAnyDesk,
//                                     label: const Text(
//                                       'Reset',
//                                       // until 1.6 maintains original size
//                                       textScaler: TextScaler.linear(1.6),
//                                       style: TextStyle(
//                                         color: Colors.cyanAccent,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     icon: Icon(
//                                       size: 27.5,
//                                       resetIconRecord.iconData,
//                                       color: resetIconRecord.color,
//                                     ),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Colors.black.withValues(alpha: 150),
//                                     ),
//                                   ),

    return ElevatedButton.icon(
      onPressed: isResetting || isLoading ? null : cubit().resetAnyDesk,
      label: isResetting || isLoading
          ? LinearProgressIndicator(borderRadius: BorderRadius.circular(8))
          : !dataExists
              ? Text(
                  'No data found to reset!',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                )
              : const Text(
                  'Reset',
                  // until 1.6 maintains original size
                  textScaler: TextScaler.linear(1.6),
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      icon: isResetting || isLoading
          ? null
          : const Icon(
              size: 27.5,
              Icons.restart_alt_rounded,
              color: Colors.cyanAccent,
            ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 150),
      ),
    );
  }
}
