import 'dart:io';
import 'dart:math';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

String parseOsVersion(String fullVersion) {
  if (Platform.isWindows) {
    // Windows format: "Windows 10 Version 2009 (Build 19045.3803)"
    final match =
        RegExp(r'Windows (\d+).*\(Build (\d+)\)').firstMatch(fullVersion);
    if (match != null) {
      return 'Windows ${match.group(1)} (${match.group(2)})';
    }
  } else if (Platform.isMacOS) {
    // macOS format: "macOS 14.0.0 (Darwin Kernel Version...)"
    final match = RegExp(r'macOS (\d+\.\d+\.\d+)').firstMatch(fullVersion);
    if (match != null) {
      return 'macOS ${match.group(1)}';
    }
  } else if (Platform.isLinux) {
    // Linux format varies, take first part
    return fullVersion.split(' ').take(2).join(' ');
  }
  return fullVersion;
}

class ResetterPage extends StatelessWidget {
  const ResetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ResetterController>;
    final isReset = Random().nextBool();
    final resetIconRecord = isReset
        ? (color: Colors.green, iconData: Icons.check_circle_outline_rounded)
        : (color: Colors.red, iconData: Icons.restart_alt_rounded);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 200),
              Colors.grey.withValues(alpha: 25),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Resets ID/Ads',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      // const SizedBox(height: 1),
                      Selector<ResetterController, bool>(
                        selector: (_, state) => state.isProcessRunning,
                        builder: (_, isProcessRunning, __) {
                          final processIconRecord = isProcessRunning
                              ? (
                                  color: Colors.green,
                                  iconData: Icons.sync_rounded
                                )
                              : (
                                  color: Colors.red,
                                  iconData: Icons.sync_disabled_rounded
                                );
                          return Text.rich(
                            TextSpan(
                              text: 'AnyDesk: ',
                              children: [
                                TextSpan(
                                  text: isProcessRunning ? 'Online' : 'Offline',
                                  style: const TextStyle().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isProcessRunning
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          );
                        },
                      ),
                      Text(
                        'OS: ${Platforms.formatName(Platform.operatingSystem)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        'Dev.By, Metaspook',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    spacing: 2.5,
                    children: [
                      Image.asset(App.assetAnyDeskLogo, scale: 2.25),
                      const SizedBox(height: 10),
                      // Reset Button
                      ElevatedButton.icon(
                        onPressed: () {
                          controller().terminateProcess();
                          controller().resetAnyDeskData();
                        },
                        label: const Text(
                          'Reset',
                          textScaler: TextScaler.linear(1.75),
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Icon(
                          size: 27.5,
                          resetIconRecord.iconData,
                          color: resetIconRecord.color,
                          applyTextScaling: true,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10.75,
                          ),
                          backgroundColor: Colors.black.withValues(alpha: 150),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'NOTE: ',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                      children: [
                        TextSpan(
                          text:
                              'This app is NOT encourages any kind of illegal usages of ${App.name}, rather educational or experimental perpose only.',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.black.withValues(alpha: 100),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    style: GoogleFonts.kodeMono(),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Copyright (c) 2024 Metaspook',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.black.withValues(alpha: 100),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
