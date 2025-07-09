// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/coordinator/governorates/controllers/gorvernorate_controller.dart';
import 'package:opms/features/coordinator/governorates/models/governorate_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/router/app_router.dart';

class GovernoratesItem extends StatelessWidget {
  final Governorate? governorate;
  // final VoidCallback onTap;

  const GovernoratesItem({
    super.key,
    this.governorate,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return InkWell(
      onTap: () => AppRoutes.toNamed(
        AppRoutes.kDistrict,
        arguments: {
          'governorateID' : governorate?.id
        }
      ),
      borderRadius: BorderRadius.circular(12.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: TRoundedContainer(
        radius: 12.r,
        showBorder: true,
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
        backgroundColor: dark ? TColors.dark : TColors.light,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circle Icon
            CircleAvatar(
              radius: 24.r,
              backgroundColor: TColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.location_on,
                color: TColors.primary,
              ),
            ),
            12.horizontalSpace,

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Governorate Name
                  Text(
                    governorate?.name ?? 'Unnamed Governorate',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white : TColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  4.verticalSpace,

                  Text(
                    'Last updated: ${Formatter.formatDate(governorate?.updatedAt) ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: dark ? Colors.white38 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon or more icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: dark ? Colors.white54 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}



