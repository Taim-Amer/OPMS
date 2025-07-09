import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/users/controllers/users_controller.dart';
import 'package:opms/features/admin/users/views/widgets/insert_user_container.dart';
import 'package:opms/features/admin/users/views/widgets/user_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UsersDesktopScreen extends StatelessWidget {
  const UsersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TRoundedContainer(
      backgroundColor: dark ? TColors.black2 : Colors.white,
      radius: 2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextWidget(
                  text: 'Users'.s16w700,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  softWrap: true,
                ),
              ],
            ),
            Sizes.spaceBtwSections.verticalSpace,

            // Content
            Expanded(
              child: GetBuilder<UsersController>(
                builder: (controller) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Users Grid
                    Expanded(
                      flex: HelperFunctions.isTabletScreen(context) ? 2 : 3,
                      child: TGridLayout(
                        itemCount: controller.usersModel.data?.length ?? 0,
                        crossCount: HelperFunctions.isTabletScreen(context) ? 1 : 3,
                        mainAxisExtent: 150.h,
                        animationType: AnimationType.slide,
                        itemBuilder: (context, index) {
                          final user = controller.usersModel.data![index];
                          return Skeletonizer(
                            enabled: controller.getUsersState == RequestState.loading,
                            child: UserItem(
                              userModel: user,
                              onEditTap: () {
                                final controller = Get.find<UsersController>();
                                controller.updateUserNameController.text = user.name ?? '';
                                controller.updateUserEmailController.text = user.email ?? '';
                                // controller.updateUserPasswordController.text = equipments[index].equipmentCost ?? '';
                                // controller.updateUserPasswordConfirmController.text = equipments[index].date ?? '';

                                final fields = [
                                  InsertFieldConfig(
                                      label: '',
                                      controller: controller.updateUserNameController,
                                      hint: 'Enter name',
                                      validator: (value) => Validator.validateEmptyText('name', value)
                                  ),
                                  InsertFieldConfig(
                                      label: '',
                                      controller: controller.updateUserEmailController,
                                      hint: 'Enter email',
                                      validator: (value) => Validator.validateEmptyText('email', value)
                                  ),
                                  InsertFieldConfig(
                                      label: '',
                                      controller: controller.updateUserPasswordController,
                                      // isNumber: true,
                                      hint: 'Enter password',
                                      validator: (value) => Validator.validateEmptyText('password', value)
                                  ),
                                  InsertFieldConfig(
                                      label: '',
                                      controller: controller.updateUserPasswordConfirmController,
                                      hint: 'Enter password confirmation',
                                      validator: (value) => Validator.validateEmptyText('password confirmation', value)
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
                          );
                        },
                      ),
                    ),

                    // Spacer
                    Sizes.spaceBtwSections.horizontalSpace,

                    // Insert User Panel
                    Expanded(
                      flex: HelperFunctions.isTabletScreen(context) ? 2 : 1,
                      child: const InsertUserContainer(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
