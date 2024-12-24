import 'package:anydesk_resetter/app.dart';
import 'package:flutter/material.dart';

class ResetterPage extends StatelessWidget {
  const ResetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(App.titleText),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: Text(
        'Starter',
        style: Theme.of(context).textTheme.titleLarge,
      )),
    );
  }
}
