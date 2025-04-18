import 'package:flutter/material.dart';

class TSlideAnimation extends StatefulWidget {
  final Widget child;
  final Offset beginOffset;
  final Duration duration;
  final Curve curve;

  const TSlideAnimation({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0.0, 0.3),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
  });

  @override
  State<TSlideAnimation> createState() => _TSlideAnimationState();
}

class _TSlideAnimationState extends State<TSlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _offsetAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
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
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
