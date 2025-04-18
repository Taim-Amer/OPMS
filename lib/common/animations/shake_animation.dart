// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TShakeAnimation extends StatefulWidget {
  final Widget child;
  const TShakeAnimation({required this.child, super.key});

  @override
  _TShakeAnimationState createState() => _TShakeAnimationState();
}

class _TShakeAnimationState extends State<TShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -5.0, end: 5.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}