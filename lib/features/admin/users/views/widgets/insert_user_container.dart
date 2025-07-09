import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

import '../../controllers/users_controller.dart';

class InsertUserContainer extends StatelessWidget {
  const InsertUserContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        title: 'Insert new user form here',
        isLoading: controller.insertUsersState == RequestState.loading,
        onSubmit: () => controller.insertUser(),
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.userNameController,
            hint: 'User Name',
            validator: (value) => Validator.validateEmptyText('name', value),
          ),
          LabeledTextFeild(
            label: '',
            controller: controller.userEmailController,
            hint: 'User Email',
            validator: (value) => Validator.validateEmptyText('email', value),
          ),
          LabeledTextFeild(
            label: '',
            controller: controller.userPasswordController,
            hint: 'User Password',
            validator: (value) => Validator.validateEmptyText('password', value),
          ),
          LabeledTextFeild(
            label: '',
            controller: controller.userPasswordConfirmController,
            hint: 'User Password Confirmation',
            validator: (value) => Validator.validateEmptyText('password confirmation', value),
          ),

        ],
      ),
    );
  }
}
