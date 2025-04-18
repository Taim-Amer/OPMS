import 'package:flutter/material.dart';

class TFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const TFadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  @override
  State<TFadeAnimation> createState() => _TFadeAnimationState();
}

class _TFadeAnimationState extends State<TFadeAnimation>
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
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
