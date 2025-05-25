import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/app/controllers/breadcrumb_controller.dart';
import 'package:opms/features/admin/budget/controller/budget_controller.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class BudgetOptionsList extends GetView<BudgetController> {
  const BudgetOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BudgetController>(
      builder: (controller) => Wrap(
        spacing: Sizes.sm,
        runSpacing: Sizes.sm,
        children: List.generate(
          controller.titles.length, (index) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Get.find<BreadcrumbController>().resetTitles();
              controller.changeSelectedChip(value: index);
              Get.find<BreadcrumbController>().addTitle('Budget');
              Get.find<BreadcrumbController>().addTitle(controller.titles[index]);
            },
            child: IntrinsicWidth(
              child: TRoundedContainer(
                backgroundColor: controller.selectedChip == index ? TColors.primary : TColors.grey.withOpacity(.4),
                radius: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.lg,
                  vertical: Sizes.sm,
                ),
                child: Center(
                  child: TextWidget(
                    text: controller.titles[index].s14w700,
                    color: controller.selectedChip == index ? TColors.white : TColors.textPrimary,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }
}

