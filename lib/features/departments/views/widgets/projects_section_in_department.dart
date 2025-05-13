// file: features/departments/views/widgets/projects_section_in_department.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/errors/empty_data_widget.dart';
import 'package:opms/common/widgets/errors/error_widget.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/features/projects/view/widgets/projects_item.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/constants/enums.dart';

import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';

class ProjectsSectionInDepartment extends StatelessWidget {
  const ProjectsSectionInDepartment({super.key});

  @override
  Widget build(BuildContext context) {
    final deptCtrl = DepartmentsController.instance;
    final projCtrl = ProjectsController.instance;

    // ensure we have all projects loaded once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      projCtrl.checkProjectsData();
    });

    return Padding(
      padding: const EdgeInsets.only(
        bottom: Sizes.secondaryPaddingSpace,
        left: Sizes.secondaryPaddingSpace,
        right: Sizes.secondaryPaddingSpace,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
                bottom: Sizes.secondaryPaddingSpace,
                left: Sizes.secondaryPaddingSpace,
                right: Sizes.secondaryPaddingSpace),
            child: TRoundedContainer(
              width: double.infinity,
              height: 400,
              backgroundColor: Colors.orangeAccent,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
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
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      InsertFieldConfig(
                        label: 'Code',
                        hint: 'Enter code',
                        controller: projCtrl.projectCode,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Code is required' : null,
                        isNumber: true,
                      ),
                      InsertFieldConfig(
                        label: 'Type',
                        hint: 'Select type',
                        controller: projCtrl.projectType,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Type is required' : null,
                        dropdownOptions: [
                          'Project',
                          'Unit'
                        ], // ← dropdown instead of text
                      ),
                    ],
                    onSubmit: () {
                      projCtrl.insertProject(
                        departmentID: deptCtrl.selectedDepartementID.value,
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
          Obx(() {
            switch (projCtrl.getProjectsRequestStatus.value) {
              case RequestState.loading:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              case RequestState.error:
                return ErrorDisplayWidget(
                  message: 'Failed to load data',
                  onRetry: () {
                    projCtrl.getProjects();
                  },
                );
              case RequestState.success:
                final all = projCtrl.projectssModel.value.data ?? [];
                final filtered = all
                    .where((p) =>
                        p.departmentId == deptCtrl.selectedDepartementID.value)
                    .toList();
                if (filtered.isEmpty) {
                  return const EmptyDataWidget(
                    message: 'No projects for this department',
                    subtitle:
                        'Try selecting a different department or add a new project.',
                  );
                }
                return Expanded(
                  child: TListView(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        Sizes.spaceBtwItems.verticalSpace,
                    itemBuilder: (_, idx) =>
                        ProjectItem(project: filtered[idx]),
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
