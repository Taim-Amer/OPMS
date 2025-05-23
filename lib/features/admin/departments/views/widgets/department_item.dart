// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/departments/models/departments_model.dart';
import 'package:opms/features/admin/departments/views/widgets/edit_department_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class DepartmentItem extends StatelessWidget {
  final Department department;
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

    final codePillBg = Colors.redAccent.withOpacity(0.2);
    const codePillText = TColors.primary;

    return Obx(() {
      final isSelected = controller.showProjects.value && controller.selectedDepartmentID.value == department.id;
      return InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: onTap,
        child: TRoundedContainer(
          showBorder: true,
          radius: 12.r,
          borderColor: isSelected ? codePillText : dark ? TColors.darkBorder : TColors.lightBorder,
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          backgroundColor: dark ? TColors.dark : TColors.grey,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: department.name!.s16w700,
                      fontSize: 24,
                      softWrap: true,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        TextWidget(
                          text: 'Code'.s17w400,
                          fontSize: 13,
                          color: dark ? TColors.light : TColors.dark,
                        ),
                        12.horizontalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: codePillBg,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TextWidget(
                            text: department.code!.s17w400,
                            fontSize: 16,
                            color: codePillText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    EditDepartmentDialog(
                      name: department.name ?? '',
                      code: department.code ?? '',
                      id: department.id ?? 0,
                    ),
                  );
                },
                child: const Icon(
                  Icons.edit_rounded,
                  size: 24,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
