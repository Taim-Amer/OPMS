import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/features/admin/roles/views/widgets/insert_role_container.dart';
import 'package:opms/features/admin/roles/views/widgets/role_item.dart';
import 'package:opms/features/admin/users/controllers/users_controller.dart';
import 'package:opms/features/admin/users/views/widgets/user_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/update_user_dialog.dart';

class UsersMobileScreen extends StatelessWidget {
  const UsersMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return TRoundedContainer(
      backgroundColor: dark ? TColors.black2 : Colors.white,
      radius: 0,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InsertRoleContainer(),
            Sizes.spaceBtwSections.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Users'.s16w700,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ],
            ),
            Sizes.spaceBtwSections.verticalSpace,
            Expanded(
              child: GetBuilder<UsersController>(
                builder: (controller) => TGridLayout(
                  itemCount: controller.usersModel.data?.length ?? 0,
                  crossCount: 1,
                  // isNeverScroll: true,
                  itemBuilder: (context, index) => Skeletonizer(
                    enabled: controller.getUsersState == RequestState.loading,
                    child: UserItem(
                      userModel: controller.usersModel.data![index],
                      onEditTap: () {
                        final controller = Get.find<UsersController>();
                        final user = controller.usersModel.data![index];

                        controller.updateUserNameController.text = user.name ?? '';
                        controller.updateUserEmailController.text = user.email ?? '';
                        // controller.updateUserPasswordController.text = user.password ?? ''; // حسب الحاجة
                        // controller.updateUserPasswordConfirmController.text = user.password ?? ''; // حسب الحاجة

                        final fields = [
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateUserNameController,
                            hint: 'Enter name',
                            validator: (value) => Validator.validateEmptyText('name', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateUserEmailController,
                            hint: 'Enter email',
                            validator: (value) => Validator.validateEmptyText('email', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateUserPasswordController,
                            hint: 'Enter password',
                            validator: (value) => Validator.validateEmptyText('password', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateUserPasswordConfirmController,
                            hint: 'Enter password confirmation',
                            validator: (value) => Validator.validateEmptyText('password confirmation', value),
                          ),
                        ];

                        Get.dialog(
                          InsertRecordDialog(
                            title: 'Update User',
                            fields: fields,
                            submitStatus: controller.updateUsersState,
                            onSubmit: () => controller.updateUser(userID: user.id ?? 0),
                            showAsset: true,
                          ),
                        );
                      },

                    ),
                  ),
                  mainAxisExtent: 150.h,
                  animationType: AnimationType.slide,
                ),
              ),
            ),
            Sizes.spaceBtwSections.verticalSpace,
          ],
        ),
      ),
    );
  }
}
