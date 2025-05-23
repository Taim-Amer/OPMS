import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';
import 'package:opms/features/projects/models/all_projects_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/router/app_router.dart';

class ProjectItem extends StatelessWidget {
  final Project project;
  const ProjectItem({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    final badgeBg = TColors.primary.withOpacity(0.2);
    final badgeTextColor = dark ? TColors.light : TColors.primary;

    final typeChar = (project.type != null && project.type!.isNotEmpty)
        ? project.type![0].toUpperCase()
        : '?';

    final codePillBg = Colors.blueAccent.withOpacity(0.2);
    const codePillText = Colors.blueAccent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.toNamed(
          AppRoutes.kOutcome,
          arguments: {
            'unitID' : project.id
          }
        ),
        child: TRoundedContainer(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          backgroundColor: dark ? TColors.dark : TColors.grey,
          showBorder: true,
          // width: double.infinity,
          borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badgeBg,
                    ),
                    alignment: Alignment.center,
                    child: TextWidget(
                      text: typeChar.s16w700,
                      fontSize: 18,
                      color: badgeTextColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: project.name!.s16w700,
                        fontWeight: FontWeight.w400,
                        softWrap: true,
                      ),
                      // SizedBox(height: 8.h),
                      Row(
                        children: [
                          TextWidget(
                            text: 'Code'.s17w400,
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
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextWidget(
                              text: project.code!.s17w400,
                              fontSize: 16,
                              color: codePillText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              IconButton(
                onPressed: (){
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
                      showAsset: true,
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
                icon: const Icon(
                Icons.edit_rounded,
                size: 24,
                color: Colors.blueAccent,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
