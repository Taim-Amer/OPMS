// ignore_for_file: must_be_immutable
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/device_utility.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  TTabBar({super.key, required this.tabs});

  List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace.w),
      child: Material(
        color: dark ? Colors.black : TColors.white,
        child: TabBar(
          tabs: tabs,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.only(right: 24.w),
          labelColor: dark ? TColors.white : TColors.primary,
          unselectedLabelColor: TColors.darkGrey,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
