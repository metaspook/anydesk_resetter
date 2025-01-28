import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: Size(487.5, 212.5),
        backgroundColor: Colors.transparent,
        title: '.\u2007AnyDesk Resetter',
        center: true,
        alwaysOnTop: true,
      ), () async {
    await windowManager.setMaximizable(false);
    await windowManager.setResizable(false);
    await windowManager.show();
    await windowManager.focus();
  });
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(devLog);
  runApp(App());
}
