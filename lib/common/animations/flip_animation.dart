import 'dart:math' as math;
import 'package:flutter/material.dart';

class TFlipAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool horizontal;

  const TFlipAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.horizontal = true,
  });

  @override
  State<TFlipAnimation> createState() => _TFlipAnimationState();
}

class _TFlipAnimationState extends State<TFlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
      builder: (_, child) {
        return Transform(
          alignment: Alignment.center,
          transform: widget.horizontal
              ? (Matrix4.identity()..rotateY(_animation.value))
              : (Matrix4.identity()..rotateX(_animation.value)),
          child: widget.child,
        );
      },
    );
  }
}
