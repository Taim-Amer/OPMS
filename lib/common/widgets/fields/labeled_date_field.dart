import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/fade_slide_animation.dart';
import 'package:opms/utils/constants/colors.dart';

class LabeledDateField extends StatefulWidget {
  const LabeledDateField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.isCentered = false,
    this.primaryColor,
    this.textNextToLabel,
    this.validator,
    this.fillColor,
    this.showLabel = false,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool isCentered;
  final Color? primaryColor;
  final String? textNextToLabel;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final bool? showLabel;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  @override
  State<LabeledDateField> createState() => _LabeledDateFieldState();
}

class _LabeledDateFieldState extends State<LabeledDateField> {
  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel ?? false) ...[
          Row(
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
          ),
          9.verticalSpace,
        ],
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: widget.initialDate ?? DateTime.now(),
              firstDate: widget.firstDate ?? DateTime(1900),
              lastDate: widget.lastDate ?? DateTime(2100),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  dialogBackgroundColor: dark ? TColors.darkContainer : TColors.light,
                  colorScheme: ColorScheme.light(
                    primary: TColors.primary,
                    onPrimary: Colors.white,
                    surface: dark ? TColors.darkContainer : TColors.light,
                    onSurface: dark ? TColors.light : TColors.dark,
                  ),
                ),
                child: child!,
              ),
            );
            if (pickedDate != null) {
              widget.controller.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              textAlign: widget.isCentered ? TextAlign.center : widget.textAlign,
              textDirection: widget.textDirection,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: dark ? TColors.light : TColors.dark,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintTextDirection: widget.textDirection,
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: const Color(0xFF707070)),
                filled: true,
                fillColor:
                widget.fillColor ?? (dark ? TColors.darkerGrey : TColors.grey),
                counterText: '',
                suffixIcon: const Icon(Icons.calendar_today, color: TColors.primary),
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
                  borderSide: const BorderSide(color: TColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
