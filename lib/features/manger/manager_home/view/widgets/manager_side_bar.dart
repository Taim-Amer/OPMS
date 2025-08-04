// lib/features/manger/manager_home/view/widgets/manager_side_bar.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/settings/controllers/theme_controller.dart';
import 'package:opms/features/manger/manager_home/controller/manager_controller.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/app_routes.dart';

class _SectionEntry {
  final IconData icon;
  final String label;
  final String routeName;
  const _SectionEntry({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}

class ManagerSideBar extends StatefulWidget {
  const ManagerSideBar({super.key});

  @override
  State<ManagerSideBar> createState() => _ManagerSideBarState();
}

class _ManagerSideBarState extends State<ManagerSideBar> {
  bool _collapsed = false;

  void _onSectionTap(int idx, _SectionEntry sec, bool isMobile) {
    final ctrl = ManagerController.instance;
    final currentlySelected = ctrl.selectedIndex.value == idx;

    final currentPath =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final onDetails = currentPath
            .startsWith('${AppRoutesNew.managerBase}/activity/') ||
        currentPath.startsWith('${AppRoutesNew.managerBase}/plan-implementation/');

    if (!isMobile && currentlySelected) {
      if (onDetails && idx == 0) {
        setState(() => _collapsed = !_collapsed);
        return;
      }
      setState(() => _collapsed = !_collapsed);
      return;
    } else if (!isMobile && _collapsed) {
      setState(() => _collapsed = false);
    }

    // Update the selected index so Obx rebuilds
    ctrl.selectedIndex.value = idx;

    // Navigate to the new route
    context.goNamed(sec.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ManagerController.instance;
    final dark = HelperFunctions.isDarkMode(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < Sizes.tabletScreenSize;

    final fullWidth =
        isMobile ? HelperFunctions.screenWidth(context) / 1.7 : 316.w;
    final minWidth = 72.w;
    final sidebarW = (_collapsed && !isMobile) ? minWidth : fullWidth;

    final sections = <_SectionEntry>[
      const _SectionEntry(
        icon: Icons.dashboard,
        label: 'Show active activities',
        routeName:AppRoutesNew.nameManagerActive,
      ),
      const _SectionEntry(
        icon: Icons.person,
        label: 'Show available users',
        routeName: AppRoutesNew.nameManagerUsers,
      ),
      const _SectionEntry(
        icon: Icons.account_tree_outlined,
        label: 'Tree',
        routeName: AppRoutesNew.nameManagerTree,
      ),
      const _SectionEntry(
        icon: Icons.hourglass_full,
        label: 'Archive',
        routeName: AppRoutesNew.nameManagerArchive,
      ),
      const _SectionEntry(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        routeName: AppRoutesNew.nameManagerNotifications,
      ),
    ];

    Widget buildExpandedContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Title on Mobile
          if (isMobile) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.sm.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    dark ? ImagesAssets.darkLogo : ImagesAssets.lightLogo,
                    width: 200.w,
                    height: 200.w,
                  ),
                  SizedBox(height: Sizes.md.h / 2),
                  "Syrian Arab Red Crescent - Operational Plan"
                      .s17w700(context),
                ],
              ),
            ),
            SizedBox(height: Sizes.md.h),
          ],

          // Navigation Items
          Container(
            decoration: BoxDecoration(
              color:
                  isMobile ? null : (dark ? TColors.darkerGrey : TColors.light),
              borderRadius: BorderRadius.circular(24.r),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Sizes.sm.h,
              horizontal: Sizes.md.w,
            ),
            child: Obx(() {
              return Column(
                children: sections.asMap().entries.map((e) {
                  final idx = e.key;
                  final sec = e.value;
                  final selected = ctrl.selectedIndex.value == idx;
                  return _SidebarItem(
                    icon: sec.icon,
                    label: sec.label,
                    isSelected: selected,
                    onTap: () => _onSectionTap(idx, sec, isMobile),
                  );
                }).toList(),
              );
            }),
          ),

          const Spacer(),

          // Settings Card
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.md.h,
              horizontal: isMobile ? Sizes.md.w : 0,
            ),
            child: InkWell(
              onTap: () => _showSettings(context, isMobile),
              borderRadius: BorderRadius.circular(30.r),
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      TColors.primary.withOpacity(0.3),
                      dark ? TColors.darkGrey : TColors.lightGrey,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: Sizes.lg.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isMobile ? 60.r : 22.r,
                      backgroundImage:
                          const AssetImage(ImagesAssets.profilePlaceHolder),
                    ),
                    SizedBox(width: Sizes.md.w),
                    Expanded(
                      child: TextWidget(
                        text: 'Manager Name'.s14w700(context),
                        color: dark ? TColors.light : TColors.dark,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showSettings(context, isMobile),
                      icon: Icon(
                        Icons.settings_rounded,
                        color: dark ? TColors.light : TColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget buildCollapsedContent() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Obx(() {
            return Column(
              children: sections.asMap().entries.map((e) {
                final idx = e.key;
                final sec = e.value;
                final selected = ctrl.selectedIndex.value == idx;
                final bgColor = selected
                    ? TColors.error
                    : (dark ? Colors.grey.shade700 : Colors.grey.shade300);
                final iconColor = selected
                    ? Colors.white
                    : (dark ? Colors.black87 : Colors.black54);

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Tooltip(
                    message: sec.label,
                    child: GestureDetector(
                      onTap: () => _onSectionTap(idx, sec, isMobile),
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(sec.icon, color: iconColor, size: 24.w),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Tooltip(
              message: 'Settings',
              child: GestureDetector(
                onTap: () {
                  setState(() => _collapsed = false);
                  _showSettings(context, isMobile);
                },
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: dark ? Colors.grey.shade700 : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.settings_rounded,
                      color: dark ? Colors.black87 : Colors.black54,
                      size: 24.w),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    final container = AnimatedContainer(
      width: sidebarW,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: dark ? TColors.black2 : const Color(0xfffffdfb),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: _collapsed && !isMobile
          ? buildCollapsedContent()
          : buildExpandedContent(),
    );

    if (isMobile) {
      return Drawer(width: sidebarW, child: container);
    } else {
      return Padding(
        padding: EdgeInsets.only(left: Sizes.md.w),
        child: container,
      );
    }
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
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

void _showSettings(BuildContext context, bool isMobile) {
  final themeCtrl = Get.find<ThemeController>();
  final managerCtrl = ManagerController.instance;

  Widget body = Column(mainAxisSize: MainAxisSize.min, children: [
    Obx(() => ListTile(
          title: const Text('Dark Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: CupertinoSwitch(
            value: themeCtrl.themeMode.value == ThemeMode.dark,
            onChanged: (v) =>
                themeCtrl.updateThemeMode(v ? ThemeMode.dark : ThemeMode.light),
          ),
        )),
    const Divider(height: 1),
    ListTile(
      leading: const Icon(Icons.logout_rounded),
      title: const Text('Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () {
        GoRouter.of(context).pop();
        managerCtrl.logout();
      },
    ),
  ]);

  if (isMobile) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: body,
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const Text('Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        content: body,
      ),
    );
  }
}
