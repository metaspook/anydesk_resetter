import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen(devLog2);
  runApp(App());
}
