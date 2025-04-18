import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

import 'package:lottie/lottie.dart';
import 'package:opms/utils/constants/assets.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget(
      {super.key, required this.child, this.height = 51, this.color});
  final Widget child;
  final double height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          child,
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: color,
                ),
                child: LottieBuilder.asset(JsonAssets.loading, height: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
