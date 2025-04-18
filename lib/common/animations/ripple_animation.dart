import 'package:flutter/material.dart';
import 'package:opms/utils/constants/colors.dart';

class TRippleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color color;

  const TRippleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.color = TColors.primary,
  });

  @override
  State<TRippleAnimation> createState() => _TRippleAnimationState();
}

class _TRippleAnimationState extends State<TRippleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // تأثير الموجات (الدخان)
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (_, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.1),
                  ),
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}
