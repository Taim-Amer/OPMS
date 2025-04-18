// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';

class TCircularMotionAnimation extends StatefulWidget {
  final Widget child;
  const TCircularMotionAnimation({required this.child, super.key});

  @override
  _TCircularMotionAnimationState createState() => _TCircularMotionAnimationState();
}

class _TCircularMotionAnimationState extends State<TCircularMotionAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: -10 * (pi / 180),
      end: 10 * (pi / 180),
    ).animate(_controller);
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
        return Transform.rotate(
          angle: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}