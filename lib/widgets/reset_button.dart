import 'dart:math';

import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ResetterController>;
    final isReset = Random().nextBool();
    final iconRecord = isReset
        ? (color: Colors.green, iconData: Icons.check_circle_outline_rounded)
        : (color: Colors.red, iconData: Icons.restart_alt_rounded);
    return ElevatedButton.icon(
      onPressed: controller().resetAnyDesk,
      label: const Text(
        'Reset',
        textScaler: TextScaler.linear(1.75),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      icon: Icon(
        size: 27.5,
        iconRecord.iconData,
        color: iconRecord.color,
        applyTextScaling: true,
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10.75,
        ),
        backgroundColor: Colors.white.withValues(alpha: 75),
      ),
    );
  }
}
