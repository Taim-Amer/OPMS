// file: features/departments/views/screens/departments_mobile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/errors/error_widget.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/shimmers/departments_shimmer.dart';
import 'package:opms/common/widgets/errors/empty_data_widget.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/departments/models/departments_model.dart';
import 'package:opms/features/departments/views/screens/projects_mobile_screen.dart';
import 'package:opms/features/departments/views/widgets/department_item.dart';
import 'package:opms/utils/constants/enums.dart';

class DepatmentsMobileScreen extends StatelessWidget {
  const DepatmentsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = DepartmentsController.instance;
    ctrl.checkDepartmentData();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: 'Departments'.s16w700,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
            InkWell(
              onTap: () {
                ctrl.departmentName.clear();
                ctrl.departemntCode.clear();
                Get.dialog(
                  InsertRecordDialog(
                    submitStatus: ctrl.insertDepartmentsRequestStatus,
                    title: 'Add Department',
                    fields: [
                      InsertFieldConfig(
                        label: 'Department Name',
                        hint: 'Enter name',
                        controller: ctrl.departmentName,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      InsertFieldConfig(
                        label: 'Code',
                        hint: 'Enter code',
                        controller: ctrl.departemntCode,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Code is required' : null,
                        isNumber: true,
                      ),
                    ],
                    onSubmit: () {
                      ctrl.insertDepartment();
                    },
                  ),
                );
              },
              child: const CustomButton(
                title: '+ New',
                radius: 6,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        switch (ctrl.getDepartmentsRequestStatus.value) {
          case RequestState.loading:
            return const DepartmentsShimmer();
          case RequestState.error:
            return ErrorDisplayWidget(
              message: 'Failed to load departments',
              onRetry: ctrl.getDepartments,
            );
          case RequestState.success:
            final List<Department> list =
                ctrl.departmentsModel.value.departments!;
            if (list.isEmpty) {
              return const EmptyDataWidget(
                message: 'No departments found',
                subtitle: 'Please add a new department to get started.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, idx) {
                final dept = list[idx];
                return DepartmentItem(
                  department: dept,
                  onTap: () {
                    ctrl.selectedDepartementID.value = dept.id!;
                    ctrl.toggleShowProjects();
                    Get.to(() => ProjectsMobileScreen(department: dept));
                  },
                );
              },
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}
