import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/activities/models/activities_model.dart';
import 'package:opms/features/admin/activities/view/widgets/edit_activity_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: TRoundedContainer(
          showBorder: true,
          radius: 12.r,
          borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          backgroundColor: dark ? TColors.dark : TColors.grey,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: activity.name!.s16w700,
                      fontSize: 24,
                      softWrap: true,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        TextWidget(
                          text: 'Code'.s17w400,
                          fontSize: 13,
                          color: dark ? TColors.light : TColors.dark,
                        ),
                        12.horizontalSpace,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TextWidget(
                            text: activity.code!.s17w400,
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                        16.horizontalSpace,
                        const Icon(
                          true == true ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: true == true ? Colors.green : Colors.red,
                        ),
                        4.horizontalSpace,
                        TextWidget(
                          text: (true == true ? 'Active' : 'Inactive').s14w400,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    if (activity.createdAt != null)
                      TextWidget(
                        text: 'Created at: ${Formatter.getFormattedDate(activity.createdAt!)}'.s14w400,
                        fontSize: 11,
                        color: dark ? TColors.light : TColors.dark,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    EditActivityDialog(
                      name: activity.name ?? '',
                      code: activity.code ?? '',
                      id: activity.id ?? 0,
                    ),
                  );
                },
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    Icons.edit_rounded,
                    size: 24,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

