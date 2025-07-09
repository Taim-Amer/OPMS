// lib/features/planner/plan_implementation/view/widgets/plan_implementation_layout.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:opms/utils/helpers/helper_functions.dart';

class PlanImplementationLayout extends StatefulWidget {
  final int planActivityId;
  final String regionType;
  final int regionId;
  final bool isEditable;

  const PlanImplementationLayout({
    super.key,
    required this.planActivityId,
    required this.regionType,
    required this.regionId,
    required this.isEditable,
  });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

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
              if (ctrl.loading || ctrl.model == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Title ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: Text(
                      'Plan Implementation for Region: '
                      '${widget.regionType} #${widget.regionId}',
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
                  Center(
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      selectedBorderColor: TColors.cresePrimarySwatch,
                      borderColor: TColors.borderPrimary.withOpacity(0.5),
                      fillColor: TColors.cresePrimarySwatch.withOpacity(0.1),
                      selectedColor: TColors.cresePrimarySwatch,
                      color: theme.textTheme.bodyMedium!.color,
                      constraints: const BoxConstraints(minWidth: 120),
                      isSelected: [
                        _currentTab == 0,
                        _currentTab == 1,
                        _currentTab == 2,
                        _currentTab == 3,
                        _currentTab == 4, // ← added
                        _currentTab == 5, // ← new
                        _currentTab == 6, // ← new
                      ],
                      onPressed: (idx) => setState(() => _currentTab = idx),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Salaries',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Volunteers',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Equipments',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Relief Items',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Running Costs', // ← new tab
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Trainings', // ← new tab
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Field Visits', // ← new tab
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: HelperFunctions.isDarkMode(context)
                                    ? TColors.textWhite
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ─── Content ────────────────────────────────────────────
                  if (_currentTab == 0) ...[
                    SalariesTable(
                      salaries: ctrl.salaries,
                      isEditable: widget.isEditable,
                      onEditSalary: ctrl.updateSalary,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      fetchSalaryOptions: ctrl.fetchSalaryOptions,
                    ),
                  ] else if (_currentTab == 1) ...[
                    VolunteersTable(
                      volunteers: ctrl.volunteers,
                      isEditable: widget.isEditable,
                      onEditVolunteer: ctrl.updateVolunteer,
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      volunteerOptions: ctrl.volunteerOptions,
                      volunteerOptionsLoading: ctrl.volunteerOptionsLoading,
                    ),
                  ] else if (_currentTab == 2) ...[
                    EquipmentsTable(
                      items: ctrl.equipments,
                      isEditable: widget.isEditable,
                      onEdit: ctrl.updateEquipment,
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
                      facilityTypes: ctrl.facilityTypes,
                      facilityTypesLoading: ctrl.facilityTypesLoading,
                      costOptions: ctrl.runningCostOptions,
                      costOptionsLoading: ctrl.runningCostOptionsLoading,
                    ),
                  ] else if (_currentTab == 5) ...[
                    FieldVisitsTable(
                      items: ctrl.fieldVisits,
                      isEditable: widget.isEditable,
                      onEdit: ctrl.updateFieldVisit,
                      visitOptions: ctrl.fieldVisitOptions,
                      visitOptionsLoading: ctrl.fieldVisitOptionsLoading,
                      salaryOptions: ctrl.salaryOptions,
                      salaryOptionsLoading: ctrl.salaryOptionsLoading,
                    ),
                  ] else /* == 6 */ ...[
                    TrainingsTable(
                      ctrl: ctrl,
                      trainings: ctrl.trainings,
                      isEditable: widget.isEditable,
                      onEditTraining: ctrl.updateTraining,
                      onEditCost: ctrl.updateTrainingCost,
                      descriptionOptions: ctrl.trainingDescriptionOptions,
                      descLoading: ctrl.trainingDescLoading,
                      subOptions: ctrl.trainingSubDescriptionOptions,
                      subLoading: ctrl.trainingSubLoading,
                    ),
                  ],

                  const SizedBox(height: 30),

                  // ─── Save Button ───────────────────────────────────────

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save_rounded),
                    label: const Text("Save as Draft"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 22),
                      elevation: 0,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width < 600
                            ? 14.5
                            : 15.5,
                      ),
                    ),
                    onPressed: () {
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
                            backgroundColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            insetPadding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 24),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: IntrinsicHeight(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header
                                    const Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange,
                                            size: 28,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text('Draft has warnings',
                                                style: headerStyle),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Divider(height: 1, thickness: 1),

                                    // Body
                                    Flexible(
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: errors.map((e) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text('• ',
                                                      style: bulletStyle),
                                                  Expanded(
                                                    child: Text(e,
                                                        style: messageStyle),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),

                                    const Divider(height: 1, thickness: 1),

                                    // Actions
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text('Fix issues',
                                                style: fixButtonStyle),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              ctrl.saveDraft();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Draft saved with warnings (see console for JSON)'),
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('Save anyway',
                                                style: saveButtonTextStyle),
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

                      // No errors → save normally
                      ctrl.saveDraft();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Draft saved (see console for JSON)'),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
