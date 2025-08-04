import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart';
import 'package:opms/features/planner/activity_plan_details/model/admin_four_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/distric_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/governorate_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/sub_distric_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/app_routes.dart';

/// Shows the Region Selector Dialog and manages drilldown + confirmation
Future<Map<String, dynamic>?> showRegionSelectorDialog(
    BuildContext context, int planActivityID) async {
  final ctrl = Get.find<ActivityPlanDetailsController>(tag: "$planActivityID");

  final selectedGovernorate = Rxn<Governorate>();
  final selectedDistrict = Rxn<District>();
  final selectedSubDistrict = Rxn<SubDistrict>();
  final selectedAdminFor = Rxn<AdminFor>();

  if (ctrl.governorates.isEmpty) ctrl.fetchGovernorates();

  void clearLowerLevels(
      {bool district = false,
      bool subDistrict = false,
      bool adminFor = false}) {
    if (district) {
      selectedDistrict.value = null;
      ctrl.districts.clear();
      clearLowerLevels(subDistrict: true);
    }
    if (subDistrict) {
      selectedSubDistrict.value = null;
      ctrl.subDistricts.clear();
      clearLowerLevels(adminFor: true);
    }
    if (adminFor) {
      selectedAdminFor.value = null;
      ctrl.adminFors.clear();
    }
  }

  dynamic getConfirmedRegion() {
    if (selectedAdminFor.value != null) {
      return {
        'id': selectedAdminFor.value!.id,
        'type': 'AdminFor',
        'name': selectedAdminFor.value!.name,
      };
    }
    if (selectedSubDistrict.value != null) {
      return {
        'id': selectedSubDistrict.value!.id,
        'type': 'SubDistrict',
        'name': selectedSubDistrict.value!.name,
      };
    }
    if (selectedDistrict.value != null) {
      return {
        'id': selectedDistrict.value!.id,
        'type': 'District',
        'name': selectedDistrict.value!.name,
      };
    }
    if (selectedGovernorate.value != null) {
      return {
        'id': selectedGovernorate.value!.id,
        'type': 'Governorate',
        'name': selectedGovernorate.value!.name,
      };
    }
    return null;
  }

  // --- Breadcrumb text ---
  String breadcrumb() {
    List<String> parts = [];
    if (selectedGovernorate.value != null) {
      parts.add(selectedGovernorate.value!.name);
    }
    if (selectedDistrict.value != null) parts.add(selectedDistrict.value!.name);
    if (selectedSubDistrict.value != null) {
      parts.add(selectedSubDistrict.value!.name);
    }
    if (selectedAdminFor.value != null) parts.add(selectedAdminFor.value!.name);
    return parts.isEmpty ? 'No region selected yet' : parts.join('  ›  ');
  }

  return await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      backgroundColor: HelperFunctions.isDarkMode(context)
          ? TColors.dark
          : const Color.fromARGB(255, 233, 230, 230),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 720, minWidth: 440, maxHeight: 640),
        child: Obx(() => Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Stack(
                children: [
                  // --- Actual dialog content (now scrollable) ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(36, 30, 36, 64),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 21,
                                backgroundColor:
                                    TColors.cresePrimarySwatch.shade50,
                                child: const Icon(Icons.location_city_rounded,
                                    size: 26,
                                    color: TColors.cresePrimarySwatch),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Select Region",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23,
                                            letterSpacing: 0.1,
                                            color: TColors.cresePrimarySwatch)),
                                    Text(
                                      "Choose any level for regional planning",
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: TColors.textSecondary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 24),
                                color: TColors.crese700,
                                splashRadius: 18,
                                tooltip: "Close",
                                onPressed: () => GoRouter.of(context).pop(),
                              ),
                            ],
                          ),
                          const Divider(height: 34, thickness: 1),

                          // --- Breadcrumb / Path ---
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, right: 2, bottom: 12),
                            child: Row(
                              children: [
                                Icon(Icons.chevron_right,
                                    color: TColors.crese300, size: 19),
                                Expanded(
                                  child: Text(
                                    breadcrumb(),
                                    style: const TextStyle(
                                        color: TColors.textSecondary,
                                        fontSize: 14.2,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Governorate
                          _RegionLevelSelector<Governorate>(
                            label: "Governorate",
                            items: ctrl.governorates,
                            loading: ctrl.governoratesLoading.value,
                            selected: selectedGovernorate.value,
                            onTap: (gov) async {
                              if (selectedGovernorate.value?.id == gov.id) {
                                return;
                              }
                              selectedGovernorate.value = gov;
                              clearLowerLevels(district: true);
                              await ctrl.fetchDistricts(gov.id);
                            },
                            color: Colors.lightBlue.withOpacity(0.3),
                            highlight: TColors.primaryBlue,
                            badge: "Level 1",
                            icon: Icons.flag_rounded,
                          ),

                          // District
                          if (selectedGovernorate.value != null)
                            _RegionLevelSelector<District>(
                              label: "District",
                              items: ctrl.districts,
                              loading: ctrl.districtsLoading.value,
                              selected: selectedDistrict.value,
                              onTap: (district) async {
                                if (selectedDistrict.value?.id == district.id) {
                                  return;
                                }
                                selectedDistrict.value = district;
                                clearLowerLevels(subDistrict: true);
                                await ctrl.fetchSubDistricts(district.id);
                              },
                              color: TColors.primaryGreen.withOpacity(0.07),
                              highlight: TColors.primaryGreen,
                              badge: "Level 2",
                              icon: Icons.apartment_rounded,
                            ),

                          // Sub District
                          if (selectedDistrict.value != null)
                            _RegionLevelSelector<SubDistrict>(
                              label: "Sub District",
                              items: ctrl.subDistricts,
                              loading: ctrl.subDistrictsLoading.value,
                              selected: selectedSubDistrict.value,
                              onTap: (subDistrict) async {
                                if (selectedSubDistrict.value?.id ==
                                    subDistrict.id) {
                                  return;
                                }
                                selectedSubDistrict.value = subDistrict;
                                clearLowerLevels(adminFor: true);
                                await ctrl.fetchAdminFors(subDistrict.id);
                              },
                              color: TColors.primaryPink.withOpacity(0.07),
                              highlight: TColors.primaryPink,
                              badge: "Level 3",
                              icon: Icons.location_on_rounded,
                            ),

                          // Admin Four
                          if (selectedSubDistrict.value != null)
                            _RegionLevelSelector<AdminFor>(
                              label: "Admin Four",
                              items: ctrl.adminFors,
                              loading: ctrl.adminForsLoading.value,
                              selected: selectedAdminFor.value,
                              onTap: (adminFor) {
                                selectedAdminFor.value = adminFor;
                              },
                              color: TColors.crese300.withOpacity(0.08),
                              highlight: TColors.cresePrimarySwatch,
                              badge: "Level 4",
                              icon: Icons.account_tree_rounded,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // --- Floating Confirm Button ---
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: HelperFunctions.isDarkMode(context)
                            ? TColors.dark
                            : const Color.fromARGB(255, 233, 230, 230),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                              color: TColors.crese900.withOpacity(0.07),
                              blurRadius: 18,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(30, 12, 30, 20),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: TColors.buttonPrimary, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              getConfirmedRegion() == null
                                  ? "No region selected"
                                  : "Selected: ${(getConfirmedRegion()!['name'])} (${getConfirmedRegion()!['type'].toString().capitalizeFirst})",
                              style: const TextStyle(
                                color: TColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check, size: 20),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.buttonPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 12),
                              elevation: 0,
                            ),
                            onPressed: getConfirmedRegion() != null
                                ? () {
                                    final region = getConfirmedRegion()!;
                                    final type = region['type'] as String;
                                    final id = region['id'] as int;

                                    // 1. Close the dialog
                                    GoRouter.of(context).pop();
                                    final isPlanEditabl =
                                        Get.find<ActivityPlanDetailsController>(
                                                tag: "$planActivityID")
                                            .isPlanEditable
                                            .value;

                                    // 2. Then navigate using the original context

                                    context.goNamed(
                                     AppRoutesNew.namePlanImplementation,
                                      pathParameters: {
                                        'planActivityId': Get.find<
                                                    ActivityPlanDetailsController>(
                                                tag: "$planActivityID")
                                            .planActivityId
                                            .toString(),
                                        'regionType': type,
                                        'regionId': id.toString(),
                                      },
                                      queryParameters: {
                                        'regionName':
                                            region['name'], // no need to encode
                                      },
                                      extra: {
                                        'isEditable': isPlanEditabl,
                                      },
                                    );
                                  }
                                : null,
                            label: const Text("Confirm"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    ),
  );
}

// --------- SINGLE LEVEL SELECTOR (Card style) ----------
class _RegionLevelSelector<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final bool loading;
  final T? selected;
  final void Function(T) onTap;
  final Color color;
  final Color highlight;
  final String badge;
  final IconData icon;

  const _RegionLevelSelector({
    required this.label,
    required this.items,
    required this.loading,
    required this.selected,
    required this.onTap,
    required this.color,
    required this.highlight,
    required this.badge,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 3),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: highlight.withOpacity(0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: highlight.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Row
          Row(
            children: [
              Icon(icon, color: highlight, size: 18),
              const SizedBox(width: 7),
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5,
                      color: highlight)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: highlight.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(badge,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: highlight,
                        fontSize: 11.8)),
              ),
            ],
          ),
          const SizedBox(height: 9),

          // Option chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((e) {
              final bool isSel = selected == e;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onTap(e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: isSel
                          ? highlight.withOpacity(isDark ? 0.31 : 0.18)
                          : isDark
                              ? Colors.white.withOpacity(0.06)
                              : TColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel ? highlight : highlight.withOpacity(0.11),
                        width: isSel ? 1.8 : 1.2,
                      ),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                  color: highlight.withOpacity(0.07),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2))
                            ]
                          : [],
                    ),
                    child: Text(
                      (e as dynamic).name,
                      style: TextStyle(
                        color: isSel
                            ? highlight
                            : (isDark ? Colors.white70 : TColors.textPrimary),
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
