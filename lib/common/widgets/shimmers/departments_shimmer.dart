import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:shimmer/shimmer.dart';

class DepartmentsShimmer extends StatelessWidget {
  const DepartmentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: TListView(
        itemCount: 6,
        separatorBuilder: (_, __) => Sizes.spaceBtwItems.verticalSpace,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: TColors.grey.withOpacity(0.3),
          highlightColor: TColors.grey.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: TColors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 0.5.sw,
                        height: 16.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 0.3.sw,
                        height: 14.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
