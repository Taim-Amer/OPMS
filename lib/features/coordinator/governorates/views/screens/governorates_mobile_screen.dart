import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/departments/views/widgets/department_item.dart';
import 'package:opms/features/admin/departments/views/widgets/new_department_dialog.dart';
import 'package:opms/features/admin/departments/views/widgets/projects_list.dart';
import 'package:opms/features/coordinator/governorates/controllers/gorvernorate_controller.dart';
import 'package:opms/features/coordinator/governorates/views/widgets/governorates_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GovernoratesMobileScreen extends GetView<GovernorateController> {
  const GovernoratesMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
      ),
      backgroundColor: dark ? TColors.black2 : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: GetBuilder<GovernorateController>(
          builder: (controller) {
            final governorates = controller.governorateModel.data;
            final isLoading = controller.getGovernoratesState == RequestState.loading || governorates == null;

            return Skeletonizer(
              enabled: isLoading,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: governorates?.length ?? 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return TSlideAnimation(
                    beginOffset: Offset(0, index.isEven ? 1 : -1),
                    child: GovernoratesItem(
                      governorate: governorates?[index],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

