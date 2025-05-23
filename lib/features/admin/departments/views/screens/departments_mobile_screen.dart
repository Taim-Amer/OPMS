import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/departments/views/widgets/department_item.dart';
import 'package:opms/features/admin/departments/views/widgets/new_department_dialog.dart';
import 'package:opms/features/admin/departments/views/widgets/projects_list.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DepartmentsMobileScreen extends GetView<DepartmentsController> {
  const DepartmentsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
        actions: [
          CustomButton(
            title: '+ New',
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onTap: () {
              controller.departemntCode.clear();
              controller.departmentName.clear();
              Get.dialog(const NewDepartmentDialog());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: dark ? TColors.black2 : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Obx(() {
          final departments = controller.departmentsModel.value.departments ?? [];
          final selectedId = controller.selectedDepartmentID.value;

          return ListView.separated(
            itemCount: departments.length,
            separatorBuilder: (context, _) => Sizes.spaceBtwItems.verticalSpace,
            itemBuilder: (context, index) {
              final department = departments[index];
              final isExpanded = selectedId == department.id;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: controller.getDepartmentsRequestStatus.value == RequestState.loading,
                    child: DepartmentItem(
                      department: department,
                      onTap: () {
                        controller.toggleShowProjects(departmentID: department.id!);
                      },
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    const ProjectsList(),
                    const SizedBox(height: 24),
                  ],
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

