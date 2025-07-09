import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/roles/models/roles_model.dart';
import 'package:opms/features/admin/roles/views/widgets/update_role_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';

class RoleItem extends StatelessWidget {
  const RoleItem({super.key, required this.rolesModel});

  final Data rolesModel;

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
          // Role Icon
          CircleAvatar(
            radius: 24.r,
            backgroundColor: TColors.primaryBlue.withOpacity(0.1),
            child: const Icon(
              Iconsax.security,
              size: 22,
              color: TColors.primaryBlue,
            ),
          ),
          12.horizontalSpace,

          // Role Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Role name + Edit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        rolesModel.name ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: TColors.primaryBlue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.dialog(
                        UpdateRoleDialog(roleID: rolesModel.id!),
                        useSafeArea: true,
                      ),
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: TColors.primaryBlue,
                      ),
                    ),
                  ],
                ),

                6.verticalSpace,

                // Guard name
                // if (rolesModel.guardName != null)
                //   Text(
                //     rolesModel.guardName!,
                //     style: TextStyle(
                //       fontSize: 13.sp,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.grey,
                //     ),
                //   ),
                //
                // 4.verticalSpace,

                // Created date
                Text(
                  'Created: ${Formatter.formatDate(rolesModel.createdAt)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),

                // Updated date
                Text(
                  'Updated: ${Formatter.formatDate(rolesModel.updatedAt)}',
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

