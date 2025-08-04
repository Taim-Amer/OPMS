// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/desktop_fileds_and_months.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/equipments_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/field_visits_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/mobile_fields_and_months.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/relief_assistance_table.dart'; // ← new import
import 'package:opms/features/planner/plan_implementation/view/widgets/running_costs_table.dart'; // ← new import
import 'package:opms/features/planner/plan_implementation/view/widgets/salaries_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/trainings_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/volunteers_table.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

class PlanImplementationLayout extends StatefulWidget {
  final int planActivityId;
  final String regionType;
  final int regionId;
  final bool isEditable;
  final String regionName;

  const PlanImplementationLayout(
      {super.key,
      required this.planActivityId,
      required this.regionType,
      required this.regionId,
      required this.isEditable,
      required this.regionName});

  @override
  State<PlanImplementationLayout> createState() =>
      _PlanImplementationLayoutState();
}

class _PlanImplementationLayoutState extends State<PlanImplementationLayout> {
  late final PlanImplementationController ctrl;
  int _currentTab =
      0; // 0=Salaries,1=Volunteers,2=Equipments,3=Relief,4=Running Costs

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(
      PlanImplementationController(),
      tag: "${widget.planActivityId}_${widget.regionType}_${widget.regionId}",
    );
    ctrl.init(
      planActivityId: widget.planActivityId,
      regionType: widget.regionType,
      regionId: widget.regionId,
      isEditable: widget.isEditable,
    );
  }

  final labels = [
    'Salaries',
    'Volunteers',
    'Equipments',
    'Relief Items',
    'Running Costs',
    'Field Visits',
    'Trainings',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final role = CacheHelper.getData(key: Keys.roleName) as String?;
    // Treat anything between 600 and 1000 as “narrow desktop”

    final screenWidth = MediaQuery.of(context).size.width;
// Aim for each button to take up roughly 1/labels.length of width,
// but not less than 80px and not more than 150px:
    final buttonMinWidth = (screenWidth / labels.length).clamp(80.0, 150.0);
    final baseColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;
    final highlightColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 8 : 32,
            horizontal: isMobile ? 0 : 18,
          ),
          child: GetBuilder<PlanImplementationController>(
            tag:
                "${widget.planActivityId}_${widget.regionType}_${widget.regionId}",
            builder: (ctrl) {
              if (ctrl.loading) {
                // ─── SHIMMER LOADING SKELETON ────────────────────────
                return LoadingShimmer(baseColor, highlightColor, width);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Title ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: Text(
                      'Plan Implementation for Region: '
                      '${widget.regionType} ${widget.regionName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 19 : 23,
                        color: TColors.cresePrimarySwatch,
                      ),
                    ),
                  ),

                  // ─── Fields & Months ────────────────────────────────────
                  if (isMobile)
                    MobileFieldsAndMonths(
                      ctrl: ctrl,
                      isEditable: widget.isEditable,
                    )
                  else
                    DesktopFieldsAndMonths(
                      ctrl: ctrl,
                      isEditable: widget.isEditable,
                    ),

                  const SizedBox(height: 30),

                  // ─── Segmented Control ───────────────────────────────────
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      selectedBorderColor: TColors.cresePrimarySwatch,
                      borderColor: TColors.borderPrimary.withOpacity(0.5),
                      fillColor: TColors.cresePrimarySwatch.withOpacity(0.1),
                      selectedColor: TColors.cresePrimarySwatch,
                      color: theme.textTheme.bodyMedium!.color,
                      constraints: BoxConstraints(
                        minWidth: buttonMinWidth,
                        minHeight: 40,
                      ),
                      isSelected:
                          List.generate(labels.length, (i) => _currentTab == i),
                      onPressed: (idx) => setState(() => _currentTab = idx),
                      children: labels.map((label) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: HelperFunctions.isDarkMode(context)
                                  ? TColors.textWhite
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ─── Content ────────────────────────────────────────────
                  if (_currentTab == 0) ...[
                    SalariesTable(
                      onAddSalary: ctrl.addSalary,
                      onDeleteRow: ctrl.deleteSalary,
                      salaries: ctrl.salaries,
                      isEditable: widget.isEditable,
                      onEditSalary: ctrl.updateSalary,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      fetchSalaryOptions: ctrl.fetchSalaryOptions,
                    ),
                  ] else if (_currentTab == 1) ...[
                    // inside your PlanImplementationLayout’s GetBuilder:
                    VolunteersTable(
                      volunteers: ctrl.volunteers,
                      isEditable: widget.isEditable,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      volunteerOptions: ctrl.volunteerOptions,
                      volunteerOptionsLoading: ctrl.volunteerOptionsLoading,
                      fetchVolunteerOptions: ctrl.fetchSalaryOptions,
                      onEditVolunteer: ctrl.updateVolunteer,
                      onAddVolunteer: ctrl.addVolunteer,
                      onDeleteVolunteer: ctrl.deleteVolunteer,
                    ),
                  ] else if (_currentTab == 2) ...[
                    EquipmentsTable(
                      items: ctrl.equipments,
                      isEditable: widget.isEditable,
                      onEdit: ctrl.updateEquipment,
                      onAdd: ctrl.addEquipment,
                      onDelete: ctrl.deleteEquipment,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      equipmentOptions: ctrl.equipmentOptions,
                      equipmentOptionsLoading: ctrl.equipmentOptionsLoading,
                    ),
                  ] else if (_currentTab == 3) ...[
                    ReliefAssistanceTable(
                      items: ctrl.reliefAssistanceItems,
                      isEditable: widget.isEditable,
                      onEdit: ctrl.updateReliefItem,
                      onAdd: ctrl.addReliefItem,
                      onDelete: ctrl.deleteReliefItem,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      reliefOptions: ctrl.reliefOptions,
                      reliefOptionsLoading: ctrl.reliefOptionsLoading,
                    ),
                  ] else if (_currentTab == 4) /* == 4 */ ...[
                    RunningCostsTable(
                      items: ctrl.runningCosts,
                      isEditable: widget.isEditable,
                      onEdit: ctrl.updateRunningCost,
                      onAdd: ctrl.addRunningCost,
                      onDelete: ctrl.deleteRunningCost,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      costOptions: ctrl.runningCostOptions,
                      costOptionsLoading: ctrl.runningCostOptionsLoading,
                    ),
                  ] else if (_currentTab == 5) ...[
                    FieldVisitsTable(
                      items: ctrl.fieldVisits,
                      isEditable: ctrl.isEditable,
                      visitOptions: ctrl.fieldVisitOptions,
                      visitOptionsLoading: ctrl.fieldVisitOptionsLoading,
                      salaryOptions:
                          ctrl.volunteerOptions, // or however you refer
                      salaryOptionsLoading: ctrl.volunteerOptionsLoading,
                      onEdit: ctrl.updateFieldVisit,
                      onAdd: ctrl.addFieldVisit,
                      onDelete: ctrl.deleteFieldVisit,
                    ),
                  ] else /* == 6 */ ...[
                    // wherever you build your TrainingsTable, e.g. in your View:

                    TrainingsTable(
                      trainings: ctrl.trainings,
                      isEditable: widget.isEditable,

                      // ─── training‐row callbacks ───────────────────────
                      onEditTraining: ctrl.updateTraining,
                      onDeleteTraining: ctrl.deleteTraining,
                      onAddTraining: ctrl.addTraining,

                      // ─── cost‐row callbacks ───────────────────────────
                      onEditCost: ctrl.updateTrainingCost,
                      onAddCost: ctrl.addCostRow,
                      onDeleteCost: ctrl.deleteCostRow,

                      // ─── dropdown data & loading flags ────────────────
                      descriptionOptions: ctrl.trainingDescriptionOptions,
                      descLoading: ctrl.trainingDescLoading,
                      subOptions: ctrl.trainingSubDescriptionOptions,
                      subLoading: ctrl.trainingSubLoading, ctrl: ctrl,
                    ),
                  ],

                  const SizedBox(height: 30),

                  // ─── Save Button ───────────────────────────────────────

                  role == "program_user"
                      ? ElevatedButton(
                          // Show spinner icon & "Saving…" while the draft is being sent:

                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.cresecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 22),
                            elevation: 0,
                          ),
                          onPressed: ctrl.savingDraft
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  final errors = ctrl.validateDraft();
                                  if (errors.isNotEmpty) {
                                    // Predefine styles
                                    const headerStyle = TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    );
                                    const messageStyle = TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                    );
                                    const bulletStyle = TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                    );
                                    const fixButtonStyle = TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange,
                                    );
                                    const saveButtonTextStyle = TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (ctx) => Dialog(
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 24),
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 600),
                                          child: IntrinsicHeight(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Header
                                                const Padding(
                                                  padding: EdgeInsets.all(24),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.orange,
                                                        size: 28,
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                            'Draft has warnings',
                                                            style: headerStyle),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                    height: 1, thickness: 1),
                                                // Body
                                                Flexible(
                                                  child: SingleChildScrollView(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24,
                                                        vertical: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: errors.map((e) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text('• ',
                                                                  style:
                                                                      bulletStyle),
                                                              Expanded(
                                                                child: Text(e,
                                                                    style:
                                                                        messageStyle),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                    height: 1, thickness: 1),
                                                // Actions
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(ctx)
                                                                .pop(),
                                                        child: const Text(
                                                            'Fix issues',
                                                            style:
                                                                fixButtonStyle),
                                                      ),
                                                      const Spacer(),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                          // Even when saving with warnings, trigger the POST:
                                                          () async {
                                                            final success =
                                                                await ctrl
                                                                    .saveDraft(
                                                                        ctx);
                                                            if (success) {
                                                              GoRouter.of(
                                                                      context)
                                                                  .pop();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Draft saved with warnings'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .orange,
                                                                ),
                                                              );
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Failed to save draft'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                ),
                                                              );
                                                            }
                                                          }();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.orange,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      24,
                                                                  vertical: 12),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                            'Save anyway',
                                                            style:
                                                                saveButtonTextStyle),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // No warnings → truly save draft
                                  final success = await ctrl.saveDraft(context);
                                  if (success) {
                                    // Navigate back to the Activity Plan Details page

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 16),
                                        backgroundColor: Colors.green.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        duration: const Duration(seconds: 3),
                                        content: const Row(
                                          children: [
                                            Icon(Icons.check_circle_outline,
                                                color: Colors.white),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Draft saved successfully!',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {}
                                },
                          child: ctrl.savingDraft
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Saving…',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // keep your dynamic sizing logic:
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.save_rounded),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Save as Draft',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    600
                                                ? 14.5
                                                : 15.5,
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Shimmer LoadingShimmer(Color baseColor, Color highlightColor, double width) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title placeholder
          Container(
            width: width * 0.6,
            height: 28,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 24),
          ),

          // Fields & Months placeholders
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 180,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 22),
                ),
              ),
              Container(
                width: 2,
                height: 180,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 180,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Tabs placeholder
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(labels.length, (i) {
                return Container(
                  width: 100,
                  height: 40,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 8),
                );
              }),
            ),
          ),

          const SizedBox(height: 30),

          // Table placeholder (one row)
          Container(
            height: 200,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
          ),

          // Add row button placeholder
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 100,
              height: 24,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 24),
            ),
          ),

          // Save button placeholder
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 160,
              height: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
