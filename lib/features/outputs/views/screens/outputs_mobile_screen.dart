import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/data_table/paginated_data_table.dart';
import 'package:opms/features/outputs/controller/outputs_controller.dart';
import 'package:opms/features/outputs/views/widgets/insert_output_container.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OutputsMobileScreen extends StatelessWidget {
  const OutputsMobileScreen({super.key, required this.fromAnother});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Scaffold(
      body: SafeArea(
        child: TRoundedContainer(
          backgroundColor: dark ? TColors.black2 : Colors.white,
          radius: 0,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  fromAnother? const InsertOutputContainer() : TRoundedContainer(
                    backgroundColor: dark ? TColors.dark : TColors.lightGrey,
                    // width: 400.w,
                    padding: EdgeInsets.all(Sizes.secondaryPaddingSpace.w),
                  ),
                  Sizes.spaceBtwSections.verticalSpace,
                  TextWidget(
                    text: 'Outputs'.s17w700,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  GetBuilder<OutputsController>(
                    builder: (controller) {
                      return Skeletonizer(
                        enabled: controller.getOutputsState == RequestState.loading || controller.dataSource == null || controller.getOutputsState != RequestState.success,
                        child: TPaginatedDataTable(
                          source: controller.dataSource!,
                          dataRowHeight: 50,
                          tableHeight: 400.h,
                          columns: [
                            DataColumn(label: TextWidget(text: 'Name'.s14w700, color: TColors.white)),
                            DataColumn(label: TextWidget(text: 'Code'.s14w700, color: TColors.white)),
                            DataColumn(label: TextWidget(text: 'Created'.s14w700, color: TColors.white)),
                            DataColumn(label: TextWidget(text: 'Updated'.s14w700, color: TColors.white)),
                            DataColumn(label: TextWidget(text: 'Actions'.s14w700, color: TColors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
