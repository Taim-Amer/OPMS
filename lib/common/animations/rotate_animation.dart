import 'package:flutter/material.dart';

class TRotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double turns;
  final Curve curve;

  const TRotateAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.turns = 1.0,
    this.curve = Curves.linear,
  });

  @override
  State<TRotateAnimation> createState() => _TRotateAnimationState();
}

class _TRotateAnimationState extends State<TRotateAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: widget.turns).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      ),
      child: widget.child,
    );
  }
}

