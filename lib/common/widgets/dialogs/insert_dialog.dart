// lib/common/widgets/dialogs/insert_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

/// Configuration for a single input in the dialog: either text or dropdown.
class InsertFieldConfig {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool isNumber;
  final Widget? prefix;
  final Widget? suffixIcon;
  final String? textNextToLabel;

  /// If non-null, renders a dropdown of these options instead of a text field.
  final List<String>? dropdownOptions;

  InsertFieldConfig({
    required this.label,
    this.hint = '',
    required this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.isNumber = false,
    this.prefix,
    this.suffixIcon,
    this.textNextToLabel,
    this.dropdownOptions,
  });
}

/// A reusable “Insert Record” dialog built on GetX.
class InsertRecordDialog extends StatefulWidget {
  /// Dialog title (e.g. “Add Department”)
  final String title;

  /// One config per input you need
  final List<InsertFieldConfig> fields;

  /// Called when user taps “Save” and form is valid
  final VoidCallback onSubmit;

  /// Loading status for the Save button
  final Rx<RequestState> submitStatus;

  const InsertRecordDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.submitStatus,
  });

  @override
  _InsertRecordDialogState createState() => _InsertRecordDialogState();
}

class _InsertRecordDialogState extends State<InsertRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes =
        List.generate(widget.fields.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Dialog(
      backgroundColor: dark ? TColors.dark : Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      text: widget.title.s16w700,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: dark ? TColors.light : TColors.dark,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: dark ? Colors.white : Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // FORM
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.defaultSpace,
                  vertical: Sizes.defaultSpace / 2,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: List.generate(widget.fields.length, (i) {
                      final f = widget.fields[i];
                      // If dropdownOptions provided, render dropdown
                      if (f.dropdownOptions != null) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: Sizes.spaceBtwItems),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextWidget(
                                    text: Text(f.label),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: dark
                                        ? TColors.light
                                        : TColors.dark,
                                  ),
                                  if (f.textNextToLabel != null) ...[
                                    8.horizontalSpace,
                                    TextWidget(
                                      text: Text(f.textNextToLabel!),
                                      color: TColors.grey,
                                    )
                                  ],
                                ],
                              ),
                              9.verticalSpace,
                              DropdownButtonFormField<String>(
                                value: f.controller.text.isEmpty
                                    ? null
                                    : f.controller.text,
                                items: f.dropdownOptions!
                                    .map((opt) =>
                                        DropdownMenuItem(
                                          value: opt,
                                          child: Text(opt),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  f.controller.text = val ?? '';
                                },
                                validator: f.validator,
                                decoration: InputDecoration(
                                  hintText: f.hint,
                                  filled: true,
                                  fillColor: dark
                                      ? TColors.darkerGrey
                                      : TColors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(6.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 14.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Otherwise render text field
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: Sizes.spaceBtwItems),
                        child: LabeledTextFeild(
                          label: f.label,
                          hint: f.hint,
                          controller: f.controller,
                          validator: f.validator,
                          keyboardType: f.keyboardType,
                          isPassword: f.isPassword,
                          isNumber: f.isNumber,
                          prefix: f.prefix,
                          suffixIcon: f.suffixIcon,
                          textNextToLabel: f.textNextToLabel,
                          focusNode: _focusNodes[i],
                          nextFocusNode: i < _focusNodes.length - 1
                              ? _focusNodes[i + 1]
                              : null,
                          textInputAction:
                              i < widget.fields.length - 1
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (i == widget.fields.length - 1) {
                              _submit();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // ACTIONS
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.secondaryPaddingSpace,
                vertical: Sizes.defaultSpace,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: 'Cancel'.s14w700,
                  ),
                  SizedBox(width: 16.w),
                  Obx(() {
                    final loading = widget.submitStatus.value ==
                        RequestState.loading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : TextWidget(
                              text: 'Save'.s14w700,
                              color: dark ? TColors.light : TColors.dark,
                              fontWeight: FontWeight.bold,
                            ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
