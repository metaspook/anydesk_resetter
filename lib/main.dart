import 'package:anydesk_resetter/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  const minimumSize = Size(400, 300);
  final windowOptions = WindowOptions(
    size: minimumSize * 1.125,
    minimumSize: minimumSize,
    center: true,
    title: 'AnyDesk Resetter',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(App());
}
