// file: features/departments/views/widgets/projects_mobile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/errors/error_widget.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/shimmers/departments_shimmer.dart';
import 'package:opms/common/widgets/errors/empty_data_widget.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/departments/models/departments_model.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';
import 'package:opms/features/projects/view/widgets/projects_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class ProjectsMobileScreen extends StatelessWidget {
  final Department department;
  const ProjectsMobileScreen({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final projCtrl = ProjectsController.instance;

    // Load projects once
    projCtrl.checkProjectsData();

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: '${department.name}'.s16w700,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: Column(
          children: [
            // The large header container
            const TRoundedContainer(
              width: double.infinity,
              height: 200,
              backgroundColor: Colors.orangeAccent,
            ),
            const SizedBox(height: Sizes.secondaryPaddingSpace),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  projCtrl.projectName.clear();
                  projCtrl.projectType.clear();
                  projCtrl.projectCode.clear();

                  Get.dialog(
                    InsertRecordDialog(
                      submitStatus: projCtrl.insertProjectRequestStatus,
                      title: 'Add Project',
                      fields: [
                        InsertFieldConfig(
                          label: 'Project Name',
                          hint: 'Enter name',
                          controller: projCtrl.projectName,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                        InsertFieldConfig(
                          label: 'Code',
                          hint: 'Enter code',
                          controller: projCtrl.projectCode,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Code is required'
                              : null,
                          isNumber: true,
                        ),
                        InsertFieldConfig(
                          label: 'Type',
                          hint: 'Select type',
                          controller: projCtrl.projectType,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Type is required'
                              : null,
                          dropdownOptions: [
                            'Project',
                            'Unit'
                          ], // ← dropdown instead of text
                        ),
                      ],
                      onSubmit: () {
                        projCtrl.insertProject(
                          departmentID: DepartmentsController
                              .instance.selectedDepartementID.value,
                        );
                      },
                    ),
                  );
                },
                child: const CustomButton(
                  title: '+ New Project',
                  radius: 6,
                  height: 40,
                ),
              ),
            ),

            // Projects list
            Expanded(
              child: Obx(() {
                switch (projCtrl.getProjectsRequestStatus.value) {
                  case RequestState.loading:
                    return const DepartmentsShimmer();
                  case RequestState.error:
                    return ErrorDisplayWidget(
                      message: 'Failed to load projects',
                      onRetry: () => projCtrl.getProjects(),
                    );
                  case RequestState.success:
                    final all = projCtrl.projectssModel.value.data ?? [];
                    final filtered = all
                        .where((p) => p.departmentId == department.id)
                        .toList();
                    if (filtered.isEmpty) {
                      return const EmptyDataWidget(
                        message: 'No projects for this department',
                        subtitle:
                            'Try adding a new project or switching departments.',
                      );
                    }
                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: Sizes.spaceBtwItems),
                      itemBuilder: (_, idx) => ProjectItem(
                        project: filtered[idx],
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
