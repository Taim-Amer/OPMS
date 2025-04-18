import 'package:flutter/material.dart';

class WrapperWidget extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget Function(Widget child)? widget;
  final Widget Function(Widget child)? fallBack;
  const WrapperWidget({
    super.key,
    required this.condition,
    required this.child,
    this.widget,
    this.fallBack,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      if (widget != null) {
        return widget!(child);
      }
    } else {
      if (fallBack != null) {
        return fallBack!(child);
      }
    }
    return child;
  }
}
