import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/admin/app/controllers/breadcrumb_controller.dart';

class RouteBreadcrumb extends StatelessWidget {
  const RouteBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BreadcrumbController>();

    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        // crossAxisAlignment: marginZero,
        children: [
          for (int i = 0; i < controller.titles.length; i++) ...[
            if (i > 0) const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.chevron_left, size: 16),
            ),
            Text(
              controller.titles[i],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: i == controller.titles.length - 1
                    ? Get.theme.primaryColor
                    : Colors.grey,
              ),
            ),
          ],
        ],
      ),
    ));
  }
}