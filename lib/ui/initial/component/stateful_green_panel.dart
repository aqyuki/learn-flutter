import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_training/ui/common/after_first_layout_mixin.dart';

class StatefulGreenPanel extends StatefulWidget {
  const StatefulGreenPanel({super.key});

  @override
  State<StatefulWidget> createState() => _StatefulGreenPanelState();
}

class _StatefulGreenPanelState extends State<StatefulGreenPanel>
    with AfterFirstLayoutMixin {
  late Timer _timer;

  @override
  void afterFirstLayout() {
    _startTimer();
  }

  void _startTimer() {
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
