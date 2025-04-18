import 'package:flutter/material.dart';

class TZoomOutAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double startScale;

  const TZoomOutAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.decelerate,
    this.startScale = 2.0,
  });

  @override
  State<TZoomOutAnimation> createState() => _TZoomOutAnimationState();
}

class _TZoomOutAnimationState extends State<TZoomOutAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(
      begin: widget.startScale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    return _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
