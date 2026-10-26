import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/ui/initial/initial_page.dart';
import 'package:flutter_training/ui/weather/weather_page.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const InitialPage(),
      routes: {
        '/weather': (BuildContext context) => const WeatherPage(),
      },
    );
  }
}
