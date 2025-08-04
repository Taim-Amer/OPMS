// lib/features/manger/manager_home/view/widgets/manager_users.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/features/manger/manager_home/model/manager_users_model.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:shimmer/shimmer.dart';
import 'package:opms/features/manger/manager_home/controller/manager_controller.dart';

import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class ManagerUsersScreen extends StatefulWidget {
  const ManagerUsersScreen({super.key});

  @override
  State<ManagerUsersScreen> createState() => _ManagerUsersState();
}

class _ManagerUsersState extends State<ManagerUsersScreen> {
  final _ctrl = ManagerController.instance;

  @override
  void initState() {
    super.initState();
    _ctrl.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < Sizes.tabletScreenSize;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final state = _ctrl.usersLoadState.value;
      if (state == RequestState.loading) {
        return _buildShimmer(isMobile, isDark);
      }
      if (state == RequestState.success) {
        final users = _ctrl.users;
        if (users.isEmpty) {
          return Center(
            child: Text(
              'No users found.',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDark ? TColors.lightGrey : TColors.darkGrey,
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: isMobile
              ? ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, idx) => _buildListItem(users[idx], isDark),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (width ~/ 300).clamp(1, 4),
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: users.length,
                  itemBuilder: (_, idx) => _buildCardItem(users[idx], isDark),
                ),
        );
      }
      // error state
      return Center(
        child: Text(
          'Failed to load users.',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.redAccent,
          ),
        ),
      );
    });
  }

  Widget _buildListItem(ManagerUser user, bool isDark) {
    return ListTile(
      tileColor: isDark ? TColors.darkContainer2 : TColors.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: CircleAvatar(
        backgroundColor: isDark ? TColors.darkBorder : TColors.crese100,
        child: Text(
          user.name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: isDark ? TColors.white : TColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? TColors.white : TColors.textPrimary,
        ),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? TColors.darkGrey : TColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildCardItem(ManagerUser user, bool isDark) {
    return Card(
      color: isDark ? TColors.darkContainer : TColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.white : TColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? TColors.darkGrey : TColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(bool isMobile, bool isDark) {
    // base & highlight colors for shimmer
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    if (isMobile) {
      return ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.count(
          crossAxisCount:
              (MediaQuery.of(context).size.width ~/ 300).clamp(1, 4),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 3 / 2,
          children: List.generate(6, (_) {
            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }),
        ),
      );
    }
  }
}
