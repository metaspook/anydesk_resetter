import 'dart:io';

import 'package:anydesk_resetter/app.dart';
import 'package:anydesk_resetter/resetter/resetter.dart';
import 'package:anydesk_resetter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetterView extends StatelessWidget {
  const ResetterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 75),
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
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Resets ID/Ads ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: App.version,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(App.assetAnyDeskLogo, scale: 2.25),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        'Dev.By, ${App.author}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 2.5,
                    children: [
                      // Reset Button
                      SizedBox(
                        width: 260,
                        child: Column(
                          spacing: 5,
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
              const Spacer(),
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
                    'Copyright (c) ${DateTime.now().year} ${App.author}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
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
