import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/errors/error_widget.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/common/widgets/shimmers/departments_shimmer.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/departments/views/widgets/departemnts_header.dart';
import 'package:opms/features/departments/views/widgets/department_item.dart';
import 'package:opms/features/departments/views/widgets/projects_section_in_department.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/handle_view.dart';

class DepartmentsDesktopScreen extends StatelessWidget {
  const DepartmentsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DepartmentsController.instance;

    // Kick off load if needed
    controller.checkDepartmentData();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    final dark = context.isDarkMode;
    return Scaffold(
      backgroundColor: dark ? TColors.deepBlack : Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            bottom: Sizes.secondaryPaddingSpace,
            left: Sizes.secondaryPaddingSpace,
            right: Sizes.secondaryPaddingSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: DepartemntsHeader(
                  scaffoldKey: scaffoldKey, controller: controller, dark: dark),
            ),
            Expanded(
              flex: 9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final total = constraints.maxWidth;
                  return Obx(() {
                    final show = controller.showProjects.value;
                    // 25% for departments, 75% for projects when shown
                    final leftWidth = show ? total * 0.25 : total;
                    final rightWidth = show ? total * 0.75 : 0.0;

                    return Row(
                      children: [
                        // Departments panel
                        AnimatedContainer(
                          width: leftWidth,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // … your Header row and +New button …
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    text: 'Departments'.s16w700,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.departmentName.clear();
                                      controller.departemntCode.clear();
                                      Get.dialog(
                                        InsertRecordDialog(
                                          submitStatus: controller
                                              .insertDepartmentsRequestStatus,
                                          title: 'Add Department',
                                          fields: [
                                            InsertFieldConfig(
                                              label: 'Department Name',
                                              hint: 'Enter name',
                                              controller:
                                                  controller.departmentName,
                                              validator: (v) =>
                                                  v == null || v.isEmpty
                                                      ? 'Name is required'
                                                      : null,
                                            ),
                                            InsertFieldConfig(
                                              label: 'Code',
                                              hint: 'Enter code',
                                              controller:
                                                  controller.departemntCode,
                                              validator: (v) =>
                                                  v == null || v.isEmpty
                                                      ? 'Code is required'
                                                      : null,
                                              isNumber: true,
                                            ),
                                          ],
                                          onSubmit: () {
                                            controller.insertDepartment();
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
                              Sizes.spaceBtwSections.verticalSpace,
                              Expanded(
                                child: HandleView(
                                  status:
                                      controller.getDepartmentsRequestStatus,
                                  loadingWidget: const DepartmentsShimmer(),
                                  errorWidget: ErrorDisplayWidget(
                                    message: 'Failed to load data',
                                    onRetry: () {
                                      controller.getDepartments();
                                    },
                                  ),
                                  successView: () {
                                    final list = controller
                                        .departmentsModel.value.departments!;
                                    if (list.isEmpty) {
                                      return Center(
                                        child: TextWidget(
                                          text: 'No departments found'.s16w400,
                                        ),
                                      );
                                    }
                                    return TListView(
                                      itemCount: list.length,
                                      separatorBuilder: (_, __) =>
                                          Sizes.spaceBtwItems.verticalSpace,
                                      itemBuilder: (_, idx) => DepartmentItem(
                                        department: list[idx],
                                        onTap: () {
                                          // your existing tap logic, e.g.:
                                          controller.selectedDepartementID
                                              .value = list[idx].id!;
                                          if (!controller.showProjects.value) {
                                            controller.toggleShowProjects();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  defaultWidget: const SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Projects panel
                        // We include it always so AnimatedContainer can animate to zero
                        AnimatedContainer(
                          width: rightWidth,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: rightWidth > 0
                              ? const ProjectsSectionInDepartment()
                              : const SizedBox.shrink(),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// … inside your DepartmentsDesktopScreen build, replace the Expanded(flex:9, child: Row(...)) block with:


