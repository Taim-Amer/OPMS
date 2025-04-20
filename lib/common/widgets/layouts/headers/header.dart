import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/settings/views/widgets/theme_icon.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget{
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: dark ? Colors.black : TColors.white,
        // border: const Border(bottom: BorderSide(color: TColors.grey, width: 1))
      ),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.md, vertical: Sizes.sm),
      child: AppBar(
        leading: !HelperFunctions.isDesktopScreen(context) ? IconButton(
          onPressed: () => scaffoldKey?.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ) : null,
        title: HelperFunctions.isDesktopScreen(context) ? SizedBox(
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search anything ...."
            ),
          ),
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
