import 'package:anydesk_resetter/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(400, 300),
    center: true,
    title: 'AnyDesk Resetter',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(App());
}
