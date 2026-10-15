import 'package:flutter/material.dart';
import 'package:flutter_training/ui/initial/component/stateful_green_panel.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: StatefulGreenPanel());
  }
}
