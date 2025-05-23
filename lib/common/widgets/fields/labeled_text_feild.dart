import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/fade_slide_animation.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';

class LabeledTextFeild extends StatefulWidget {
  const LabeledTextFeild({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.isPassword = false,
    this.isNumber = false,
    this.textAlign = TextAlign.start,
    this.isCentered = false,
    this.textDirection,
    this.primaryColor,
    this.textNextToLabel,
    this.validator,
    this.keyboardType,
    this.svgSize,
    this.suffixIcon,
    this.maxLength = 40,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.prefix,
    this.fillColor,
    this.showLabel = false
  });

  final Widget? prefix;
  final bool isPassword;
  final bool isNumber;
  final String label;
  final String hint;
  final double? svgSize;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool isCentered;
  final TextEditingController controller;
  final Color? primaryColor;
  final Widget? suffixIcon;
  final String? textNextToLabel;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLength;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final bool? showLabel;

  @override
  State<LabeledTextFeild> createState() => _LabeledTextFeildState();
}

class _LabeledTextFeildState extends State<LabeledTextFeild> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showLabel ?? false ? Row(
          children: [
            TFadeSlideAnimation(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: widget.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),    
              ),
            ),
            if (widget.textNextToLabel != null) ...[
              8.horizontalSpace,
              Text(widget.textNextToLabel!,
                  style: const TextStyle(color: TColors.grey)),
            ],
          ],
        ) : const SizedBox(),
        widget.showLabel ?? false ? 9.verticalSpace : const SizedBox(),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: TColors.primary.withOpacity(.3)
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            enableInteractiveSelection: false,
            cursorColor: TColors.primary,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: dark ? TColors.light : TColors.dark, fontWeight: FontWeight.w400),
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: (value) {
              if (widget.textInputAction == TextInputAction.next) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
              widget.onFieldSubmitted?.call(value);
            },
            maxLength: widget.maxLength,
            textAlign: widget.isCentered ? TextAlign.center : widget.textAlign,
            textDirection: widget.textDirection,
            validator: widget.validator,
            keyboardType: widget.keyboardType ??
                (widget.isNumber ? TextInputType.number : null),
            inputFormatters: [
              if (widget.isNumber)
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: widget.prefix,
                ),
                prefixIconConstraints:
                    const BoxConstraints(maxHeight: 20 + 16),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: const Color(0xFF707070)),
                hintTextDirection: widget.textDirection,
                filled: true,
                fillColor: widget.fillColor ?? (dark ? TColors.darkerGrey : TColors.grey),
                hintText: widget.hint,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(
                      color: TColors.primary), // Customize if needed
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide:
                      const BorderSide(color: Colors.red), // Keeps the radius
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide:
                      const BorderSide(color: Colors.red), // Keeps the radius
                ),
                suffixIcon: widget.suffixIcon ??
                    (widget.isPassword
                        ? IconButton(
                            onPressed: () {
                              isVisible = !isVisible;
                              setState(() {});
                            },
                            icon: isVisible
                                ? SvgPicture.asset(SvgAssets.eye)
                                : SvgPicture.asset(SvgAssets.eyeSlash))
                        : null)),
            obscureText: widget.isPassword && !isVisible,
          ),
        ),
      ],
    );
  }
}
