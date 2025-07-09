import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/images/rounded_image.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/departments/views/widgets/department_item.dart';
import 'package:opms/features/admin/projects/controller/projects_controller.dart';
import 'package:opms/features/admin/projects/view/widgets/projects_item.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/features/admin/roles/views/widgets/role_item.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/users_controller.dart';

class AddUserToRoleDialog extends GetView<UsersController> {
  const AddUserToRoleDialog({super.key, required this.userID});

  final int userID;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return AlertDialog(
      backgroundColor: dark ? TColors.dark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      actionsPadding: const EdgeInsets.only(bottom: 12, right: 12, top: 8),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Assign Role & Departments',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: TColors.primaryBlue,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () => Get.back(),
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionCard(child: _buildRoleDropdown(), label: 'Role', context: context),
              16.verticalSpace,
              _sectionCard(child: _buildDepartmentChips(), label: 'Departments', context: context),
              16.verticalSpace,
              _sectionCard(child: _buildUnitChips(), label: 'Units', context: context),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
        ),
        GetBuilder<UsersController>(
          builder: (controller) => CustomButton(
          onTap: _onSubmit,
          // style: ElevatedButton.styleFrom(
          //   backgroundColor: TColors.primaryBlue,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // ),
          title: 'Confirm',
          // isLoading: controller.addRoleForUserStats == RequestState.loading,
          // child: const Text('Confirm'),
        ),
        )
      ],
    );
  }

  /// Section Container with label
  Widget _sectionCard({required Widget child, required String label, required BuildContext context}) {
    final dark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        8.verticalSpace,
        TRoundedContainer(
          padding: const EdgeInsets.all(12),
          radius: 12.r,
          backgroundColor: dark ? TColors.dark : Colors.white,
          showBorder: true,
          borderColor: Colors.grey.withOpacity(0.3),
          child: child,
        ),
      ],
    );
  }

  /// Role Dropdown
  Widget _buildRoleDropdown() {
    final isDark = Get.context!.isDarkMode;
    return GetBuilder<RolesController>(
      builder: (ctrl) {
        return CustomDropdown<String>(
          items: ctrl.rolesModel.data?.map((item) => item.name ?? '').toList() ?? [],
          hintText: 'Select Role',
          onChanged: (selectedName) {
            final selectedItem =
            ctrl.rolesModel.data?.firstWhere((item) => item.name == selectedName);
            controller.setRoleID(id: selectedItem?.id ?? 0);
          },
          decoration: CustomDropdownDecoration(
            closedFillColor: isDark ? TColors.dark : Colors.white,
            expandedFillColor: isDark ? TColors.dark : Colors.white,
            closedBorderRadius: BorderRadius.circular(12),
            expandedBorderRadius: BorderRadius.circular(12),
            closedShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            expandedShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
            hintStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14.sp,
            ),
            headerStyle: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          disabledDecoration: CustomDropdownDisabledDecoration(
            fillColor: isDark ? TColors.dark.withOpacity(0.8) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey,
            ),
            headerStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        );
      },
    );
  }

  /// Department Chips
  Widget _buildDepartmentChips() {
    final depts = Get.find<DepartmentsController>().departmentsModel.value;
    return GetBuilder<UsersController>(
      builder: (controller) {
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          children: depts.departments?.map((dept) {
            final selected = controller.departmentsIDs.contains(dept.id);
            return FilterChip(
              label: Text(
                dept.name!,
                style: TextStyle(
                  color: selected ? TColors.light : TColors.primary,
                ),
              ),
              selected: selected,
              onSelected: (selectedNow) {
                selectedNow
                    ? controller.departmentsIDs.add(dept.id!)
                    : controller.departmentsIDs.remove(dept.id);
                controller.update();
              },
              backgroundColor: Get.context!.isDarkMode ? TColors.dark : Colors.white,
              selectedColor: TColors.primary,
              checkmarkColor: TColors.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected ? TColors.primary : Get.context!.isDarkMode ? TColors.dark : Colors.white,
                  width: 1,
                ),
              ),
            );
          }).toList() ?? [],
        );
      },
    );
  }

  /// Unit Chips
  Widget _buildUnitChips() {
    final units = Get.find<ProjectsController>().allProjectsModel.value.data;
    return GetBuilder<UsersController>(
      builder: (controller) {
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          children: units?.map((unit) {
            final selected = controller.unitsIDs.contains(unit.id);
            return FilterChip(
              label: Text(
                unit.name!,
                style: TextStyle(
                  color: selected ? TColors.light : TColors.primary,
                ),
              ),
              selected: selected,
              onSelected: (selectedNow) {
                selectedNow
                    ? controller.unitsIDs.add(unit.id!)
                    : controller.unitsIDs.remove(unit.id);
                controller.update();
              },
              backgroundColor: Get.context!.isDarkMode ? TColors.dark : Colors.white,
              selectedColor: TColors.primary,
              checkmarkColor: TColors.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected ? TColors.primary : Get.context!.isDarkMode ? TColors.dark : Colors.white,
                  width: 1,
                ),
              ),
            );
          }).toList() ?? [],
        );
      },
    );
  }

  void _onSubmit() {
    controller.addRoleForUser(userID: userID);
    Get.back();
  }
}




