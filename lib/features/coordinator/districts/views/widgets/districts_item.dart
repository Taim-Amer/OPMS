import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/features/coordinator/districts/model/districts_model.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/helpers/map_helper.dart';

import '../../../risk_assessments/views/widgets/insert_risk_dialog.dart';

class DistrictItem extends StatelessWidget {
  final GovernorateArea district;
  final VoidCallback? onTap;

  const DistrictItem({
    super.key,
    required this.district,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    final coords = district.boundary?.coordinates;
    // Determine if there's at least one polygon with one ring of points
    final hasPolygon = coords != null
        && coords.isNotEmpty
        && coords[0].isNotEmpty
        && coords[0][0].isNotEmpty;

    // Flatten the first polygon's first ring into LatLng points
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

    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        padding: const EdgeInsets.all(12),
        radius: 12.r,
        showBorder: true,
        borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
        backgroundColor: dark ? TColors.dark : TColors.light,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Map preview or placeholder icon
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: TColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: hasPolygon
                  ? ClipOval(
                child: SizedBox(
                  width: 64.r,
                  height: 64.r,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCameraFit: CameraFit.bounds(
                        bounds: bounds,
                        padding: const EdgeInsets.all(6),
                        maxZoom: 12.0,
                      ),
                      minZoom: 5,
                      maxZoom: 15,
                      cameraConstraint:
                      CameraConstraint.contain(bounds: syriaBounds),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: polygonPoints,
                            borderColor: TColors.primaryBlue,
                            borderStrokeWidth: 2,
                            color: TColors.primaryBlue.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
                  : const Icon(
                Icons.location_off,
                color: TColors.primaryBlue,
              ),
            ),

            12.horizontalSpace,

            // District name
            Expanded(
              child: Text(
                district.name ?? 'Unnamed District',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: dark ? Colors.white : Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Zoom button
            IconButton(
              onPressed: hasPolygon
                  ? () {
                if (onTap != null) {
                  onTap!();
                } else {
                  MapHelper.showFullMap(context, bounds, polygonPoints, syriaBounds, );
                }
              } : null,
              icon: Icon(
                Icons.zoom_out_map,
                color: hasPolygon
                    ? (dark ? Colors.white54 : Colors.grey)
                    : Colors.grey.withOpacity(0.4),
              ),
            ),

            // Add risk button
            IconButton(
              onPressed: () {
                if (district.id != null) {
                  Get.dialog(
                    InsertRiskDialog(districtID: district.id!),
                  );
                }
              },
              icon: const Icon(Icons.add, color: TColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
}
