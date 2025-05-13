import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/headers/header.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/utils/constants/colors.dart';

class DepartemntsHeader extends StatelessWidget {
  const DepartemntsHeader({
    super.key,
    required this.scaffoldKey,
    required this.controller,
    required this.dark,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final DepartmentsController controller;
  final bool dark;

  static const double _toggleButtonWidth = 160; // fixed width in design dp

  @override
  Widget build(BuildContext context) {
    return THeader(
      showSearchField: false,
      scaffoldKey: scaffoldKey,
      actions: [
        Obx(() {
          final showing = controller.showProjects.value;
          return SizedBox(
            width: _toggleButtonWidth.w,
            height: 40.h,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.toggleShowProjects();
              
              },
              icon: Icon(
                showing
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 20,
                color: showing
                    ? Colors.white
                    : (dark ? TColors.light : TColors.dark),
              ),
              label: TextWidget(
                text:
                    showing ? 'Hide Projects'.s14w400 : 'Show Projects'.s14w400,
                color: showing
                    ? Colors.white
                    : (dark ? TColors.light : TColors.dark),
                fontWeight: FontWeight.w500,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: showing
                    ? TColors.primary
                    : (dark
                        ? TColors.darkerGrey.withOpacity(0.6)
                        : TColors.grey.withOpacity(0.3)),
                elevation: showing ? 4 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                // padding is handled by SizedBox, so we can let the label center naturally
              ),
            ),
          );
        }),
      ],
    );
  }
}
