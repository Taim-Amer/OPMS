import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/handlers/breadcrumb_widget.dart';
import 'package:opms/features/admin/settings/views/widgets/theme_icon.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/app_router.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget{
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final currentRoute = Get.currentRoute;
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.black2 : TColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.md, vertical: Sizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: dark ? TColors.light : TColors.dark),
        leading: !HelperFunctions.isDesktopScreen(context) ? IconButton(
          onPressed: () => scaffoldKey?.currentState?.openDrawer(),
          icon: Icon(Icons.menu, color: dark ? TColors.light : TColors.black2,),
        ) : null,
        title: HelperFunctions.isDesktopScreen(context) ? Row(
          children: [
            if(currentRoute != AppRoutes.kSidebar) IconButton(
              onPressed: () => AppRoutes.back(),
              icon: const Icon(Icons.arrow_back_ios_new,),
            ),
            Sizes.spaceBtwSections.horizontalSpace,
            const RouteBreadcrumb(),
          ],
        ) : null,
        actions: [
          const ThemeIcon(),
          if(!HelperFunctions.isDesktopScreen(context))IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 15);
}