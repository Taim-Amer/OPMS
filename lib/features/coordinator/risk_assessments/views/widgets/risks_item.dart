// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/coordinator/risk_assessments/models/risk_model.dart';
import 'package:opms/features/coordinator/risk_assessments/views/widgets/insert_risk_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/helpers/map_helper.dart';
import 'package:opms/utils/router/app_router.dart';

class RisksItem extends StatelessWidget {
  final RiskItem? risk;

  const RisksItem({super.key, this.risk});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final heavyValue = (risk?.heavy ?? 0).clamp(1, 5);
    print(heavyValue);
    print(heavyValue);
    print(heavyValue);
    print(heavyValue);
    print(heavyValue);
    // final heavyPercent = heavyValue / 5.0;
    final heavyPercent = (6 - heavyValue) / 5.0;
    final heavyColor = _getHeavyColor(heavyValue);

    final coords = risk?.district?.boundary?.coordinates;
    final hasPolygon = coords != null
        && coords.isNotEmpty
        && coords[0].isNotEmpty
        && coords[0][0].isNotEmpty;

    final List<LatLng> polygonPoints = [];
    if (hasPolygon) {
      final firstPolygon = coords![0];      // List<List<List<double>>>
      final firstRing = firstPolygon[0];    // List<List<double>>
      polygonPoints.addAll(
          firstRing.map((point) => LatLng(point[1], point[0]))
      );
    }

    final bounds = polygonPoints.isNotEmpty
        ? LatLngBounds.fromPoints(polygonPoints)
        : LatLngBounds(const LatLng(32.0, 35.0), const LatLng(38.0, 43.0));
    final syriaBounds = LatLngBounds(
      const LatLng(32.0, 35.0),
      const LatLng(38.0, 43.0),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      child: TRoundedContainer(
        radius: 12.r,
        showBorder: true,
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
        backgroundColor: dark ? TColors.dark : TColors.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: heavyColor.withOpacity(0.2),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: heavyColor,
                    size: 28,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    risk?.district?.name ?? 'Unknown District',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white : TColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => MapHelper.showFullMap(context, bounds, polygonPoints, syriaBounds, heavy: heavyValue),
                  icon: Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: dark ? Colors.white54 : Colors.grey,
                  ),
                ),
              ],
            ),
            12.verticalSpace,

            Wrap(
              runSpacing: 6,
              spacing: 16,
              children: [
                _buildInfoRow(Icons.science_outlined, 'Factor', risk?.factor?.title),
                _buildInfoRow(Icons.calendar_today_outlined, 'Year',
                    risk?.year?.toString()),
                _buildInfoRow(Icons.date_range_outlined, 'Quarter',
                    risk?.quarter),
                _buildInfoRow(Icons.update, 'Updated',
                    Formatter.formatDate(risk?.updatedAt)),
              ],
            ),
            12.verticalSpace,

            /// مؤشر التثقيل
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Level (${risk?.heavy ?? 0}/5)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: dark ? Colors.white70 : TColors.textSecondary,
                  ),
                ),
                6.verticalSpace,
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: heavyPercent,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(heavyColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    final dark = Get.context!.isDarkMode;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: dark ? Colors.white60 : Colors.grey),
        4.horizontalSpace,
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white70 : TColors.textSecondary,
          ),
        ),
        Text(
          value ?? '--',
          style: TextStyle(
            fontSize: 13.sp,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Color _getHeavyColor(int value) {
    switch (value) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}




