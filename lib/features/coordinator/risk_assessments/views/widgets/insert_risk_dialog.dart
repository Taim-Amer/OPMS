import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/features/admin/factors/controllers/factors_controller.dart';
import 'package:opms/features/coordinator/risk_assessments/controllers/risk_controller.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InsertRiskDialog extends StatelessWidget {
  const InsertRiskDialog({super.key, required this.districtID});

  final int districtID;

  Widget _sectionCard({required Widget child, required String label}) {
    final dark = Get.context!.isDarkMode;
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

  Widget _buildFactors() {
    final factors = Get.find<FactorsController>().factorsModel.data;

    return GetBuilder<FactorsController>(
      builder: (factorCtrl) {
        return GetBuilder<RiskController>(
          builder: (controller) => Wrap(
          spacing: 8,
          runSpacing: 6,
          children: (factors ?? []).map((factor) {
            final selected = controller.factorId == factor.id;
            return Skeletonizer(
              enabled: factorCtrl.getFactorsState == RequestState.loading,
              child: SizedBox(
                height: 50,
                child: FilterChip(
                  label: Text(
                    factor.title ?? '',
                    style: TextStyle(
                      color: selected ? TColors.light : TColors.primary,
                    ),
                  ),
                  selected: selected,
                  onSelected: (isNowSelected) {
                    controller.setFactorId(isNowSelected ? factor.id! : 0);
                  },
                  backgroundColor: Get.context!.isDarkMode ? TColors.dark : Colors.white,
                  selectedColor: TColors.primary,
                  checkmarkColor: TColors.light,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected
                          ? TColors.primary
                          : (Get.context!.isDarkMode ? TColors.dark : Colors.white),
                      width: 1,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final ctrl = Get.find<RiskController>();

    return AlertDialog(
      backgroundColor: isDark ? TColors.dark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      actionsPadding: const EdgeInsets.only(bottom: 12, right: 12, top: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Add New Risk',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: TColors.primaryBlue)),
          IconButton(
              icon: Icon(Icons.close, color: Colors.grey[600]),
              onPressed: () => Get.back()),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: GetBuilder<RiskController>(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Year
                _sectionCard(
                  label: 'Year',
                  child: CustomDropdown<String>(
                    items: ctrl.years,
                    hintText: 'Select Year',
                    // value: ctrl.selectedYear,
                    onChanged: ctrl.setYear,
                    decoration: CustomDropdownDecoration(
                      closedFillColor: isDark ? TColors.dark : Colors.white,
                      expandedFillColor: isDark ? TColors.dark : Colors.white,
                      closedBorderRadius: BorderRadius.circular(12),
                      expandedBorderRadius: BorderRadius.circular(12),
                    ),
                    disabledDecoration: CustomDropdownDisabledDecoration(
                      fillColor:
                      isDark ? TColors.dark.withOpacity(0.8) : Colors.grey[100]!,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                16.verticalSpace,

                // Quarter
                _sectionCard(
                  label: 'Quarter',
                  child: CustomDropdown<String>(
                    items: ctrl.quarters,
                    hintText: 'Select Quarter',
                    // value: ctrl.selectedQuarter,
                    onChanged: ctrl.setQuarter,
                    decoration: CustomDropdownDecoration(
                      closedFillColor: isDark ? TColors.dark : Colors.white,
                      expandedFillColor: isDark ? TColors.dark : Colors.white,
                      closedBorderRadius: BorderRadius.circular(12),
                      expandedBorderRadius: BorderRadius.circular(12),
                    ),
                    disabledDecoration: CustomDropdownDisabledDecoration(
                      fillColor:
                      isDark ? TColors.dark.withOpacity(0.8) : Colors.grey[100]!,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // 16.verticalSpace,

                16.verticalSpace,
                _sectionCard(child: _buildFactors(), label: 'Factors'),
                // 16.verticalSpace,
                //
                // // District ID
                // _sectionCard(
                //   label: 'District ID',
                //   child: LabeledTextField(
                //     label: '',
                //     onChanged: ctrl.setDistrictId,
                //     keyboardType: TextInputType.number,
                //     validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                //   ),
                // ),
                16.verticalSpace,

                // Heavy
                _sectionCard(
                  label: 'Heavy',
                  child: CustomDropdown<String>(
                    items: ctrl.heavies,
                    hintText: 'Select Heavy',
                    // value: ctrl.selectedHeavy,
                    onChanged: ctrl.setHeavy,
                    decoration: CustomDropdownDecoration(
                      closedFillColor: isDark ? TColors.dark : Colors.white,
                      expandedFillColor: isDark ? TColors.dark : Colors.white,
                      closedBorderRadius: BorderRadius.circular(12),
                      expandedBorderRadius: BorderRadius.circular(12),
                    ),
                    disabledDecoration: CustomDropdownDisabledDecoration(
                      fillColor:
                      isDark ? TColors.dark.withOpacity(0.8) : Colors.grey[100]!,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700]))),
        GetBuilder<RiskController>(
          builder: (_) => CustomButton(
            title: 'Submit',
            onTap: () {
              ctrl.insertRisk(
                districtID: districtID
              );
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
