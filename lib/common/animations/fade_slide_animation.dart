import 'package:flutter/material.dart';

class TFadeSlideAnimation extends StatefulWidget {
  final Widget child;
  final Offset beginOffset;
  final Duration duration;
  final Curve curve;

  const TFadeSlideAnimation({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0, 0.2),
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
  });

  @override
  State<TFadeSlideAnimation> createState() => _TFadeSlideAnimationState();
}

class _TFadeSlideAnimationState extends State<TFadeSlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _offsetAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _opacityAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);
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
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }
}
