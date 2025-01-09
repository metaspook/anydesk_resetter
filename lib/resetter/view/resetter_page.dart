import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/shared/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// color: const Color(0xfff0443c),
class ResetterPage extends StatelessWidget {
  const ResetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ResetterCubit(processRepo: context.read<ProcessRepo>()),
      child: const ResetterView(),
    );
  }
}
