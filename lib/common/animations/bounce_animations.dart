import 'package:flutter/material.dart';

class TBounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const TBounceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.bounceOut,
  });

  @override
  State<TBounceAnimation> createState() => _TBounceAnimationState();
}

class _TBounceAnimationState extends State<TBounceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.forward();
  }

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
