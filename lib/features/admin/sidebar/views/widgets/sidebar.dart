import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/images/rounded_image.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/features/admin/sidebar/controllers/sidebar_controller.dart';
import 'package:opms/features/admin/sidebar/views/widgets/menu_item.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class TSidebar extends GetView<SidebarController> {
  const TSidebar({super.key, required this.clickableSidebar});

  final bool clickableSidebar;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Sizes.spaceBtwSections.verticalSpace,
                  Center(
                    child: TRoundedImage(
                      imageUrl: dark ? ImagesAssets.darkLogo : ImagesAssets.lightLogo,
                      useHero: false,
                      width: 190,
                      height: 190,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Sizes.spaceBtwSections.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      'MENU'.s12w400,
                      Sizes.spaceBtwSections.verticalSpace,
                      TListView(
                        itemCount: 8,
                        animationType: AnimationType.slide,
                        shrink: true,
                        itemBuilder: (context, index) => MenuItem(index: index, clickableSidebar: clickableSidebar),
                        separatorBuilder: (context, _) => Sizes.spaceBtwItems.verticalSpace,
                      ),
                    ],
                  ),
                ],
              ),
              clickableSidebar ? SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => controller.logout(),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: clickableSidebar ? TColors.primary : TColors.darkerGrey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.sm),
                    child: TextWidget(
                      text: 'Logout'.s14w700,
                      fontWeight: FontWeight.w700,
                      color: TColors.primary,
                    ),
                  ),
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
