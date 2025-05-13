// file: features/activities/views/screens/activities_desktop_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/errors/empty_data_widget.dart';
import 'package:opms/common/widgets/errors/error_widget.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/activities/controller/activites_controler.dart';
import 'package:opms/features/activities/view/screens/widgets/activity_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class ActivitiesDesktopScreen extends StatelessWidget {
  const ActivitiesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = ActivitiesController.instance;
    // initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.fetchActivities();
    });

    final dark = context.isDarkMode;
    return Scaffold(
      backgroundColor: dark ? TColors.deepBlack : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: Column(
          children: [
            // ───────────── HEADER ─────────────
            Row(
              children: [
                // Search field
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search activities...',
                      prefixIcon: Icon(Icons.search,
                          color: dark ? Colors.white54 : Colors.black54),
                      filled: true,
                      fillColor: dark ? TColors.darkerGrey : TColors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onFieldSubmitted: (v) {
                      ctrl.searchQuery.value = v.trim();
                      ctrl.fetchActivities(page: 1);
                    },
                  ),
                ),

                SizedBox(width: 16.w),

                // Per-page selector
                Obx(() => DropdownButton<int>(
                      value: ctrl.perPage.value,
                      items: [10, 20, 50, 100]
                          .map((n) => DropdownMenuItem(
                                value: n,
                                child: Text('$n'),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) ctrl.fetchActivities(page: 1, perPageOverride: v);
                      },
                    )),

                SizedBox(width: 24.w),

                // Prev page
                Obx(() => IconButton(
                      icon: Icon(Icons.chevron_left_rounded,
                          color: ctrl.currentPage.value > 1
                              ? (dark ? Colors.white : Colors.black)
                              : Colors.grey),
                      onPressed: ctrl.currentPage.value > 1
                          ? () => ctrl.fetchActivities(page: ctrl.currentPage.value - 1)
                          : null,
                    )),

                // Page indicator
                Obx(() => TextWidget(
                      text: '${ctrl.currentPage.value} / ${ctrl.lastPage.value}'.s14w400,
                      fontSize: 14,
                    )),

                // Next page
                Obx(() => IconButton(
                      icon: Icon(Icons.chevron_right_rounded,
                          color: ctrl.currentPage.value < ctrl.lastPage.value
                              ? (dark ? Colors.white : Colors.black)
                              : Colors.grey),
                      onPressed: ctrl.currentPage.value < ctrl.lastPage.value
                          ? () => ctrl.fetchActivities(page: ctrl.currentPage.value + 1)
                          : null,
                    )),
              ],
            ),
            SizedBox(height: Sizes.spaceBtwSections),

            // ───────────── LIST ─────────────
            Expanded(
              child: Obx(() {
                switch (ctrl.getActivitiesStatus.value) {
                  case RequestState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case RequestState.error:
                    return ErrorDisplayWidget(
                      message: 'Failed to load activities',
                      onRetry: () => ctrl.fetchActivities(),
                    );
                  case RequestState.success:
                    final list = ctrl.activities;
                    if (list.isEmpty) {
                      return const EmptyDataWidget(
                        message: 'No activities found',
                        subtitle: 'Try changing your search or filters',
                      );
                    }
                    return TListView(
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          Sizes.spaceBtwItems.verticalSpace,
                      itemBuilder: (_, idx) =>
                          ActivityItem(activity: list[idx]),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
