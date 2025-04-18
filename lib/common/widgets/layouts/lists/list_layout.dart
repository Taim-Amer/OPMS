import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:opms/utils/constants/enums.dart';

class TListView extends StatelessWidget {
  const TListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.padding,
    this.animationType = AnimationType.fadeIn,
    this.shrink = false,
    this.isNeverScroll = false,
    this.physics,
    this.direction = Axis.vertical,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final AnimationType animationType;
  final bool shrink;
  final bool isNeverScroll;
  final ScrollPhysics? physics;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: shrink,
        scrollDirection: direction,
        physics: isNeverScroll
            ? const NeverScrollableScrollPhysics()
            : physics ?? const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: getAnimation(index, context),
          );
        },
        separatorBuilder: separatorBuilder,
      ),
    );
  }

  Widget getAnimation(int index, context) {
    switch (animationType) {
      case AnimationType.slide:
        return SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: itemBuilder(context, index),
          ),
        );
      case AnimationType.scale:
        return ScaleAnimation(
          scale: 0.5,
          child: FadeInAnimation(
            child: itemBuilder(context, index),
          ),
        );
      case AnimationType.rotate:
        return Transform.rotate(
          angle: 0.2,
          child: FadeInAnimation(
            child: itemBuilder(context, index),
          ),
        );
      case AnimationType.fadeIn:
        return FadeInAnimation(
          child: itemBuilder(context, index),
        );
      case AnimationType.none:
      default:
        return itemBuilder(context, index);
    }
  }
}
