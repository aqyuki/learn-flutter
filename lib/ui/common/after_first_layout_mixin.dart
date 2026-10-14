import 'dart:async';

import 'package:flutter/material.dart';

mixin AfterFirstLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();

    unawaited(() async {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) {
        return;
      }

      afterFirstLayout();
    }());
  }

  void afterFirstLayout();
}
