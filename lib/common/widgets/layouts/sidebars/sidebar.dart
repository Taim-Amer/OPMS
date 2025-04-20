import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/images/rounded_image.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/features/home/views/widgets/menu_item.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.white,
          // border: const Border(right: BorderSide(color: TColors.grey, width: 1))
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const TRoundedImage(imageUrl: ImagesAssets.logo, useHero: false, backgroundColor: Colors.transparent,),
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
                    itemBuilder: (context, index) => MenuItem(index: index),
                    separatorBuilder: (context, _) => Sizes.spaceBtwItems.verticalSpace,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
