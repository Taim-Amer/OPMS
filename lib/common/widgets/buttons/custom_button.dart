import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:measure_size_builder/measure_size_builder.dart';
import 'package:opms/common/widgets/handlers/wraper_widget.dart';
import 'package:opms/common/widgets/loaders/custom_loading_widget.dart';
import 'package:opms/utils/constants/colors.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final String? svg;
  final double? radius;
  final double? svgSize;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final bool isColorsToggled;
  final void Function()? onTap;
  final bool isLoading;
  final double? height;
  final MouseCursor cursor;

  const CustomButton({
    super.key,
    this.color = TColors.primary,
    required this.title,
    this.onTap,
    this.isColorsToggled = false,
    this.svg,
    this.radius,
    this.isLoading = false,
    this.svgSize,
    this.padding,
    this.cursor = SystemMouseCursors.click,
    this.height = 50,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double height = 51;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return SizedBox(
      height: widget.height,
      child: WrapperWidget(
        condition: widget.isLoading,
        widget: (child) => CustomLoadingWidget(
          height: height,
          child: child,
        ),
        fallBack: (child) => child,
        child: MeasureSizeBuilder(builder: (context, size) {
          height = size.height;
          return MouseRegion(
            cursor: widget.cursor,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: widget.padding ?? EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12.r),
                  color: widget.isColorsToggled ? dark ? TColors.dark : TColors.white : widget.color,
                  border: widget.isColorsToggled ? Border.all(width: 1, color: widget.color) : null,
                ),
                child: widget.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.svg != null) ...[
                      SizedBox(
                        width: widget.svgSize ?? 20.h,
                        height: widget.svgSize ?? 20.h,
                        child: SvgPicture.asset(widget.svg!, color: TColors.white,),
                      ),
                      8.horizontalSpace,
                    ],
                    Flexible(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: !widget.isColorsToggled ? TColors.white : widget.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
