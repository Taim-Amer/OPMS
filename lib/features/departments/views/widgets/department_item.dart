// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/departments/models/departments_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class DepartmentItem extends StatelessWidget {
  final Department department;

  /// Called when the user taps the department card.
  final VoidCallback onTap;

  const DepartmentItem({
    super.key,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final controller = DepartmentsController.instance;

    // light red for the code pill
    final codePillBg = Colors.redAccent.withOpacity(0.1);
    final codePillText = Colors.redAccent.shade700;

    return Obx(() {
      final isSelected = controller.showProjects.value &&
          controller.selectedDepartementID.value == department.id;

      return InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),

        // now using the passed-in callback
        onTap: onTap,

        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: Sizes.defaultSpace / 2,
          ),
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          decoration: BoxDecoration(
            color: dark
                ? TColors.darkerGrey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: dark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
            border: isSelected
                ? Border.all(color: Colors.redAccent, width: 2)
                : null,
          ),
          child: Row(
            children: [
              // Name & code label + pill
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: department.name!.s16w700,
                      fontWeight: FontWeight.w700,
                      softWrap: true,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        TextWidget(
                          text: 'Code'.s13w400,
                          fontSize: 13,
                          color: dark ? TColors.light : TColors.dark,
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: codePillBg,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: TextWidget(
                            text: department.code!.s13w400,
                            fontSize: 13,
                            color: codePillText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // edit icon (unchanged)
              GestureDetector(
                onTap: () {
                  final controller = DepartmentsController.instance;
                  controller.departmentName.text = department.name ?? '';
                  controller.departemntCode.text = department.code ?? '';
                  Get.dialog(
                    InsertRecordDialog(
                      submitStatus:
                          controller.updateDepartmentsRequestStatus,
                      title: 'Edit Department',
                      fields: [
                        InsertFieldConfig(
                          label: 'Department Name',
                          hint: 'Enter name',
                          controller: controller.departmentName,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                        InsertFieldConfig(
                          label: 'Code',
                          hint: 'Enter code',
                          controller: controller.departemntCode,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Code is required'
                              : null,
                          isNumber: true,
                        ),
                      ],
                      onSubmit: () {
                        if (controller.departmentName.text ==
                                department.name &&
                            controller.departemntCode.text ==
                                department.code) {
                          Get.back();
                          return;
                        }
                        controller.updateDepartment(
                          departemtnID: department.id!,
                        );
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.edit_rounded,
                  size: 24,
                  color: dark ? TColors.light : TColors.dark,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
