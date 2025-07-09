import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/users/controllers/users_controller.dart';
import 'package:opms/features/admin/users/models/users_model.dart';
import 'package:opms/features/admin/users/views/widgets/add_user_to_role_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/router/app_router.dart';

class UserItem extends GetView<UsersController> {
  const UserItem({
    super.key,
    required this.userModel,
    required this.onEditTap,
  });

  final Data userModel;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final initials = (userModel.name?.isNotEmpty ?? false)
        ? userModel.name![0].toUpperCase()
        : '?';

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: dark ? TColors.grey.withOpacity(.2) : TColors.grey,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: dark ? TColors.darkerGrey : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Circle
          CircleAvatar(
            radius: 24.r,
            backgroundColor: TColors.primaryBlue.withOpacity(0.1),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 18.sp,
                color: TColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          12.horizontalSpace,
          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name & Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        userModel.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: TColors.primaryBlue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            Get.dialog(AddUserToRoleDialog(userID: userModel.id ?? 0));
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: TColors.primaryBlue,
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
                  ],
                ),

                6.verticalSpace,

                /// Created At
                Text(
                  'Created: ${Formatter.formatDate(userModel.createdAt)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),

                2.verticalSpace,

                /// Updated At
                Text(
                  'Updated: ${Formatter.formatDate(userModel.updatedAt)}',
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

