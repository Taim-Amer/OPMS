import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class TGridLayout extends StatelessWidget {
  const TGridLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisExtent,
    this.childAspectRatio,
    this.animationType = AnimationType.none,
    this.shrink = false,
    this.isNeverScroll = false,
  });

  final int itemCount;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;
  final AnimationType animationType;
  final bool shrink;
  final bool isNeverScroll;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: shrink,
        physics: isNeverScroll
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: TSizes.spaceBtwItems.h,
          crossAxisSpacing: TSizes.spaceBtwItems.w,
          mainAxisExtent: mainAxisExtent,
          childAspectRatio: childAspectRatio ?? 1,
        ),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 600),
            columnCount: 2,
            child: getAnimation(index, context),
          );
        },
      ),
    );
  }

  Widget getAnimation(int index, context) {
    switch (animationType) {
      case AnimationType.slide:
        return SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: itemBuilder(context, index)!,
          ),
        );
      case AnimationType.scale:
        return ScaleAnimation(
          scale: .6,
          child: FadeInAnimation(
            child: itemBuilder(context, index)!,
          ),
        );
      case AnimationType.rotate:
        return Transform.rotate(
          angle: 0.2,
          child: FadeInAnimation(
            child: itemBuilder(context, index)!,
          ),
        );
      case AnimationType.fadeIn:
        return FadeInAnimation(
          child: itemBuilder(context, index)!,
        );
      case AnimationType.none:
      default:
        return itemBuilder(context, index)!;
    }
  }
}
