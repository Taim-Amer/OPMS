import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/factors/models/factors_model.dart';
import 'package:opms/features/admin/factors/views/widgets/update_factor_dialog.dart';
import 'package:opms/features/admin/roles/models/roles_model.dart';
import 'package:opms/features/admin/roles/views/widgets/update_role_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';

class FactorItem extends StatelessWidget {
  const FactorItem({
    super.key,
    required this.factor,
    required this.onEditTap,
  });

  final Factor factor;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: dark ? TColors.grey.withOpacity(0.2) : TColors.grey,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: dark ? TColors.darkerGrey : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundColor: TColors.primaryBlue.withOpacity(0.1),
            child: const Icon(
              Iconsax.setting,
              size: 22,
              color: TColors.primaryBlue,
            ),
          ),
          12.horizontalSpace,

          // Factor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title + Edit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        factor.title ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: TColors.primaryBlue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: onEditTap,
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: TColors.primaryBlue,
                      ),
                    ),
                  ],
                ),

                6.verticalSpace,

                /// Created
                Text(
                  'Created: ${Formatter.formatDate(factor.createdAt)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),

                /// Updated
                Text(
                  'Updated: ${Formatter.formatDate(factor.updatedAt)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
