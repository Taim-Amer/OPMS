import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertRoleContainer extends StatelessWidget {
  const InsertRoleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RolesController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        title: 'Insert new role form here',
        isLoading: controller.insertRolesState == RequestState.loading,
        onSubmit: () => controller.insertRole(),
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.roleNameController,
            hint: 'Role Name',
            validator: (value) => Validator.validateEmptyText('role name', value),
          ),
        ],
      ),
    );
  }
}
