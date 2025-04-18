import 'package:flutter/material.dart';

class TLoopRotation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const TLoopRotation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<TLoopRotation> createState() => _TLoopRotationState();
}

class _TLoopRotationState extends State<TLoopRotation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}
