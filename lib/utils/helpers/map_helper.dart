import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:opms/utils/constants/colors.dart';

class MapHelper {
  static void showFullMap(
      BuildContext context,
      LatLngBounds bounds,
      List<LatLng> polygonPoints,
      LatLngBounds syriaBounds, {
        int? heavy,
      }) {
    Color getBorderColor(int? h) {
      switch (heavy) {
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

    final borderColor = getBorderColor(heavy);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox.expand(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: FlutterMap(
                  options: MapOptions(
                    initialCameraFit: CameraFit.bounds(
                      bounds: bounds,
                      padding: const EdgeInsets.all(20),
                      maxZoom: 12.0,
                    ),
                    minZoom: 5,
                    maxZoom: 15,
                    cameraConstraint: CameraConstraint.contain(
                      bounds: syriaBounds,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    if (polygonPoints.isNotEmpty)
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: polygonPoints,
                            borderColor: borderColor,
                            borderStrokeWidth: 2,
                            color: borderColor.withOpacity(0.3),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: IconButton(
                    icon:
                    const Icon(Icons.zoom_in_map, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
