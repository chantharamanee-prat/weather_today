import 'package:flutter/material.dart';
import 'package:weather_today/cores/injection.dart';
import 'package:weather_today/cores/routes/router.dart';
import 'package:weather_today/cores/theme/theme.dart';

void main() async {
  await injectService();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: router,
    );
  }
}