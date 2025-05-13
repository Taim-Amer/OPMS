import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/settings/views/widgets/theme_icon.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

/// A responsive app header that lets you inject custom action widgets,
/// and toggle its built-in search field via an external RxBool.
// ignore: must_be_immutable
class THeader extends StatelessWidget implements PreferredSizeWidget {
  /// Key to open the drawer on mobile/desktop
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Extra action widgets to display after the built-in ones.
  final List<Widget> actions;

  /// Controls whether the search bar is visible.
  bool? showSearchField;

  THeader({
    super.key,
    this.scaffoldKey,
    this.actions = const [],
    this.showSearchField = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final isDesktop = HelperFunctions.isDesktopScreen(context);

    // built-in search toggle icon
    Widget searchToggle() => IconButton(
          icon: Icon(
            showSearchField! ? Icons.close_rounded : Icons.search_rounded,
            color: dark ? Colors.white : Colors.black,
          ),
          onPressed: () {},
        );

    return Container(
      decoration: BoxDecoration(color: dark ? Colors.black : TColors.white),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.md,
        vertical: Sizes.sm,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: !isDesktop
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon:
                    Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
              )
            : null,
        // Show the search field whenever showSearchField == true
        title: showSearchField!
            ? SizedBox(
                width: isDesktop ? 400 : double.infinity,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: dark ? Colors.white54 : Colors.black54),
                    hintText: "Search anything....",
                    filled: true,
                    fillColor: dark ? TColors.darkerGrey : TColors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: dark ? Colors.white : Colors.black),
                ),
              )
            : null,
        actions: [
          ...actions,
          const ThemeIcon(),
          searchToggle(),
          // any custom actions passed in:
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 15);
}
