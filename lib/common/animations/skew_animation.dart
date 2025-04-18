import 'package:flutter/material.dart';

class TSkewAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const TSkewAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<TSkewAnimation> createState() => _TSkewAnimationState();
}

class _TSkewAnimationState extends State<TSkewAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _skewAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _skewAnimation = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _skewAnimation,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(0, 1, _skewAnimation.value),
          child: widget.child,
        );
      },
    );
  }
}

