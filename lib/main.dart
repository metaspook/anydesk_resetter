import 'package:anydesk_resetter/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(500, 237.5),
    backgroundColor: Colors.transparent,
    title: 'AnyDesk Resetter',
    center: true,
    alwaysOnTop: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMaximizable(false);
    await windowManager.setResizable(false);
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(App());
}
