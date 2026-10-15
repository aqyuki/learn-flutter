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
    unawaited(_startTimer());
  }

  Future<void> _startTimer() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }

    _timer = Timer(const Duration(milliseconds: 500), () async {
      await Navigator.pushNamed<void>(context, '/weather');
      if (!mounted) {
        return;
      }

      unawaited(_startTimer());
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
