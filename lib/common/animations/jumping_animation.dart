import 'package:flutter/material.dart';

class TJumpingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double jumpHeight;

  const TJumpingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800), this.jumpHeight = 20,
  });

  @override
  State<TJumpingAnimation> createState() => _TJumpingAnimationState();
}

class _TJumpingAnimationState extends State<TJumpingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _jumpAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _jumpAnimation = Tween<double>(begin: 0.0, end: -widget.jumpHeight)
        .chain(CurveTween(curve: Curves.elasticInOut))
        .animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _jumpAnimation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _jumpAnimation.value),
          child: widget.child,
        );
      },
    );
  }
}
