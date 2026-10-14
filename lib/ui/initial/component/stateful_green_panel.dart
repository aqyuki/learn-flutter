import 'dart:async';

import 'package:flutter/material.dart';

class StatefulGreenPanel extends StatefulWidget {
  const StatefulGreenPanel({super.key});

  @override
  State<StatefulWidget> createState() => _StatefulGreenPanelState();
}

class _StatefulGreenPanelState extends State<StatefulGreenPanel> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    unawaited(_initTimer());
  }

  Future<void> _initTimer() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }

    _timer = Timer(const Duration(milliseconds: 500), () async {
      await Navigator.pushNamed<void>(context, '/weather');
      if (!mounted) {
        return;
      }

      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
