import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';
import 'package:opms/features/projects/models/all_projects_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class ProjectItem extends StatelessWidget {
  final Project project;
  const ProjectItem({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    // Background/text colors for the badge
    final badgeBg =
        dark ? TColors.grey.withOpacity(0.2) : TColors.primary.withOpacity(0.2);
    final badgeTextColor = dark ? TColors.light : TColors.primary;

    // First letter of `type`, uppercased
    final typeChar = (project.type != null && project.type!.isNotEmpty)
        ? project.type![0].toUpperCase()
        : '?';

    final codePillBg = Colors.blueAccent.withOpacity(0.1);
    final codePillText = Colors.blueAccent.shade700;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.defaultSpace / 2),
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
      ),
      child: Row(
        children: [
          // ---- Leading badge ----
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeBg,
            ),
            alignment: Alignment.center,
            child: TextWidget(
              text: typeChar.s16w700,
              fontSize: 16,
              color: badgeTextColor,
            ),
          ),

          SizedBox(width: 12.w),

          // ---- Name & code pill ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: project.name!.s16w700,
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
                        text: project.code!.s13w400,
                        fontSize: 13,
                        color: codePillText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---- Open icon ----
          GestureDetector(
            onTap: () {
              final controller = ProjectsController.instance;
              controller.projectName.text = project.name ?? '';

              // extract the substring after the last comma (or use whole code if no comma)
              final fullCode = project.code ?? '';
              final codeNumber = fullCode.contains('.')
                  ? fullCode.split('.').last.trim()
                  : fullCode;
              controller.projectCode.text = codeNumber;

              Get.dialog(
                InsertRecordDialog(
                  submitStatus: controller.updateProjectRequestStatus,
                  title: 'Edit Project',
                  fields: [
                    InsertFieldConfig(
                      label: 'Project Name',
                      hint: 'Enter name',
                      controller: controller.projectName,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Name is required' : null,
                    ),
                    InsertFieldConfig(
                      label: 'Code',
                      hint: 'Enter code',
                      controller: controller.projectCode,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Code is required' : null,
                      isNumber: true,
                    ),
                  ],
                  onSubmit: () {
                    if (controller.projectName.text == project.name &&
                        controller.projectCode.text == codeNumber) {
                      Get.back();
                      return;
                    }
                    controller.updateProject(
                      unitID: project.id!,
                      projectID: project.departementID!,
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
    );
  }
}
