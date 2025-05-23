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
      // height: 70.h,
      showBorder: true,
      radius: 6,
      borderColor: dark ? TColors.grey.withOpacity(.3) : TColors.grey,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.security, size: 30, color: TColors.primaryBlue,),
                  4.horizontalSpace,
                  TextWidget(
                    text: rolesModel.name?.s16w700 ?? const Text(''),
                    fontWeight: FontWeight.w700,
                    softWrap: true,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Get.dialog(
                  UpdateRoleDialog(roleID: rolesModel.id!,),
                  useSafeArea: true,
                ),
                icon: const Icon(Icons.edit, size: 20, color: TColors.primaryBlue,),
              )
            ],
          ),
          Sizes.sm.verticalSpace,
          TextWidget(
            text: rolesModel.guardName?.s14w700 ?? const Text(''),
            fontSize: 13,
            softWrap: true,
          ),
          TextWidget(
            text: 'Created : ${Formatter.formatDate(rolesModel.createdAt)}'.s17w700,
            fontSize: 13,
            softWrap: true,
          ),
          Sizes.sm.verticalSpace,
          TextWidget(
            text: 'Updated : ${Formatter.formatDate(rolesModel.updatedAt)}'.s17w700,
            fontSize: 13,
            softWrap: true,
          )
        ],
      ),
    );
  }
}
