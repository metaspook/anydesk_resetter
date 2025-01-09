import 'dart:io';
import 'dart:math';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class ResetterView extends StatelessWidget {
  const ResetterView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetterCubit>;
    final isReset = Random().nextBool();
    final resetIconRecord = isReset
        ? (color: Colors.green, iconData: Icons.check_circle_outline_rounded)
        : (color: Colors.red, iconData: Icons.restart_alt_rounded);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // color: Colors.black.withValues(alpha: 75),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 75),
              Colors.grey.withValues(alpha: 25),
              Colors.white,
              // Colors.white,
              // Colors.black,
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
                      BlocSelector<ResetterCubit, ResetterState, bool>(
                        selector: (state) => state.anyDeskOnline,
                        builder: (context, anyDeskOnline) {
                          final processStatusRecord = anyDeskOnline
                              ? (
                                  text: 'Online',
                                  color: Colors.green,
                                  iconData: Icons.sync_rounded
                                )
                              : (
                                  text: 'Offline',
                                  color: Colors.red,
                                  iconData: Icons.sync_disabled_rounded
                                );
                          return Text.rich(
                            TextSpan(
                              text: 'AnyDesk: ',
                              children: [
                                TextSpan(
                                  text: processStatusRecord.text,
                                  style: const TextStyle().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: processStatusRecord.color,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 2.5,
                    children: [
                      Image.asset(App.assetAnyDeskLogo, scale: 2.25),
                      // Reset Button
                      const SizedBox(
                        width: 260,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            KeepDataCheckbox(),
                            ResetterButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'i. This app is NOT encourages any kind of illegal use of ${App.processName}, rather educational or experimental perpose only.',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 1.25),
                  Text(
                    'Copyright (c) ${DateTime.now().year} Metaspook',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                          // fontWeight: FontWeight.bold,
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
