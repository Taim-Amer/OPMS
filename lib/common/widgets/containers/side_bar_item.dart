import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final bg = BoxDecoration(
      border: Border.all(color: Colors.grey.withOpacity(0.1)),
      gradient: isSelected
          ? LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                TColors.primary.withOpacity(0.8),
                TColors.primary.withOpacity(0.2),
              ],
            )
          : null,
      borderRadius: BorderRadius.circular(30.r),
    );
    final iconBg = isSelected
        ? TColors.primary
        : (dark
            ? TColors.grey.withOpacity(0.2)
            : TColors.grey.withOpacity(0.1));
    final fgColor =
        isSelected ? TColors.white : (dark ? TColors.light : TColors.dark);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.sm.h),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60.h,
            decoration: bg,
            padding: EdgeInsets.symmetric(horizontal: Sizes.lg.w),
            child: Row(
              children: [
                Container(
                  width: HelperFunctions.isMobileScreen(context) ? 70.w : 20.w,
                  height: HelperFunctions.isMobileScreen(context) ? 70.w : 20.w,
                  decoration:
                      BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(icon,
                      color: fgColor,
                      size: HelperFunctions.isMobileScreen(context)
                          ? 40.w
                          : 15.w),
                ),
                SizedBox(width: Sizes.md.w),
                Expanded(
                  child: TextWidget(
                    text: HelperFunctions.isMobileScreen(context)
                        ? label.s12w700(context)
                        : label.s14w700(context),
                    color: fgColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
