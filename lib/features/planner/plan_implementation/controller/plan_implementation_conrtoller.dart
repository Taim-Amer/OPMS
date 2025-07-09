// lib/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart

// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:get/get.dart';
import 'package:opms/features/planner/plan_implementation/model/equipment_model.dart';

import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';
import 'package:opms/features/planner/plan_implementation/model/field_visit_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/field_visit_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/months_model.dart';
import 'package:opms/features/planner/plan_implementation/model/relief_assistance_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/running_cost_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_options_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_cost_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_description_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_sub_description_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/volunteer_model.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/features/planner/plan_implementation/model/plan_implementation_model.dart';
import 'package:opms/utils/api/data_state.dart';

class PlanImplementationController extends GetxController {
  bool loading = true;
  late int planActivityId;
  late String regionType;
  late int regionId;
  late bool isEditable;
  List<EquipmentItem> get equipments =>
      model?.equipments ?? const <EquipmentItem>[];
  List<EquipmentOptionModel> equipmentOptions = [];
  bool equipmentOptionsLoading = false;
  PlanImplementationModel? model;
  List<MonthModel> allMonths = [];
  List<int> selectedMonthsIds = [];

  /// 4th table: running_costs
  List<RunningCostItem> get runningCosts =>
      model?.runningCosts ?? const <RunningCostItem>[];
  List<RunningCostOptionModel> runningCostOptions = [];
  bool runningCostOptionsLoading = false;

  List<SalaryItem> get salaries => model?.salaries ?? [];
  List<VolunteerItem> get volunteers => model?.volunteers ?? [];

  List<FacilityTypeModel> facilityTypes = [];
  bool facilityTypesLoading = false;

  final Map<int, List<TrainingSubDescriptionOptionModel>>
      trainingSubDescriptionOptions = {};
  final Map<int, bool> trainingSubLoading = {};

  List<SalaryOptionModel> volunteerOptions = [];
  bool volunteerOptionsLoading = false;

  bool trainingDescLoading = false;

  Future<void> fetchTrainingDescriptionOptionsOnce() async {
    if (trainingDescriptionOptions.isNotEmpty) return;
    trainingDescLoading = true;
    update();

    final resp = await Get.find<ApiService>()
        .getData<List<TrainingDescriptionOptionModel>>(
      endPoint: 'training_descriptions',
      fromJson: (json) => (json['data'] as List)
          .map((e) => TrainingDescriptionOptionModel.fromJson(e))
          .toList(),
    );

    if (resp is DataSuccess<List<TrainingDescriptionOptionModel>>) {
      trainingDescriptionOptions = resp.data!;
    }

    trainingDescLoading = false;
    update();
  }

  Future<void> fetchTrainingSubDescriptions(int descriptionId) async {
    // skip if we already have them
    if (trainingSubDescriptionOptions.containsKey(descriptionId)) return;
    trainingSubLoading[descriptionId] = true;
    update();

    final resp = await Get.find<ApiService>()
        .getData<List<TrainingSubDescriptionOptionModel>>(
      endPoint: 'training_sub_descriptions',
      queryParameters: {'training_description_id': descriptionId},
      fromJson: (json) => (json['data'] as List)
          .map((e) => TrainingSubDescriptionOptionModel.fromJson(e))
          .toList(),
    );

    if (resp is DataSuccess<List<TrainingSubDescriptionOptionModel>>) {
      trainingSubDescriptionOptions[descriptionId] = resp.data!;
    } else {
      trainingSubDescriptionOptions[descriptionId] = [];
    }

    trainingSubLoading[descriptionId] = false;
    update();
  }

  void updateTraining(int index, TrainingItem newItem) {
    if (model == null) return;
    final copy = [...model!.trainings];
    copy[index] = newItem;
    model = model!.copyWith(trainings: copy);
    update();
  }

  void updateTrainingCost(
      int trainingIndex, int costIndex, TrainingCostItem newCost) {
    if (model == null) return;
    final allTrainings = [...model!.trainings];
    final t = allTrainings[trainingIndex];
    final newCosts = [...t.trainingCosts];
    newCosts[costIndex] = newCost;
    allTrainings[trainingIndex] = t.copyWith(trainingCosts: newCosts);
    model = model!.copyWith(trainings: allTrainings);
    update();
  }

  List<ReliefAssistanceItem> get reliefAssistanceItems =>
      model?.reliefAssistanceItems ?? [];
  List<ReliefAssistanceOptionModel> reliefOptions = [];
  bool reliefOptionsLoading = false;

  /// _salaryOptionsCache holds fetched salary‐option lists keyed by type.
  final Map<String, List<SalaryOptionModel>> _salaryOptionsCache = {};

  List<FieldVisitItem> get fieldVisits =>
      model?.fieldVisits ?? const <FieldVisitItem>[];
  List<FieldVisitOptionModel> fieldVisitOptions = [];
  bool fieldVisitOptionsLoading = false;

  List<TrainingItem> get trainings => model?.trainings ?? const [];
  List<TrainingDescriptionOptionModel> trainingDescriptionOptions = [];
  bool trainingDescriptionOptionsLoading = false;
  Map<int, List<TrainingSubDescriptionOptionModel>> subDescriptionOptions = {};
  Map<int, bool> subDescriptionOptionsLoading = {};

  Future<void> fetchFieldVisitOptionsOnce() async {
    if (fieldVisitOptions.isNotEmpty) return;
    fieldVisitOptionsLoading = true;
    update();
    final resp =
        await Get.find<ApiService>().getData<List<FieldVisitOptionModel>>(
      endPoint: 'field_visits',
      fromJson: (json) => (json['data'] as List)
          .map((e) => FieldVisitOptionModel.fromJson(e))
          .toList(),
    );
    if (resp is DataSuccess<List<FieldVisitOptionModel>>) {
      fieldVisitOptions = resp.data!;
    }
    fieldVisitOptionsLoading = false;
    update();
  }

  Future<void> fetchTrainingDescriptions() async {
    if (trainingDescriptionOptions.isNotEmpty) return;
    trainingDescriptionOptionsLoading = true;
    update();
    final resp = await Get.find<ApiService>()
        .getData<List<TrainingDescriptionOptionModel>>(
      endPoint: 'training_descriptions',
      fromJson: (j) => (j['data'] as List)
          .map((e) => TrainingDescriptionOptionModel.fromJson(e))
          .toList(),
    );
    if (resp is DataSuccess) trainingDescriptionOptions = resp.data!;
    trainingDescriptionOptionsLoading = false;
    update();
  }

  Future<void> fetchSubDescriptions(int descriptionId) async {
    if (subDescriptionOptions.containsKey(descriptionId)) return;
    subDescriptionOptionsLoading[descriptionId] = true;
    update();
    final resp = await Get.find<ApiService>()
        .getData<List<TrainingSubDescriptionOptionModel>>(
      endPoint: 'training_sub_descriptions',
      queryParameters: {'training_description_id': descriptionId},
      fromJson: (j) => (j['data'] as List)
          .map((e) => TrainingSubDescriptionOptionModel.fromJson(e))
          .toList(),
    );
    if (resp is DataSuccess) subDescriptionOptions[descriptionId] = resp.data!;
    subDescriptionOptionsLoading[descriptionId] = false;
    update();
  }

  void updateFieldVisit(int index, FieldVisitItem newItem) {
    if (model == null) return;
    final copy = [...model!.fieldVisits];
    copy[index] = newItem;
    model = model!.copyWith(fieldVisits: copy);
    update();
  }

  void updateSalary(int index, SalaryItem newItem) {
    if (model == null) return;
    final updated = [...model!.salaries!];
    updated[index] = newItem;
    model = model!.copyWith(salaries: updated);
    update();
  }

  Future<void> fetchRunningCostOptionsOnce() async {
    if (runningCostOptions.isNotEmpty) return;
    runningCostOptionsLoading = true;
    update();

    final resp =
        await Get.find<ApiService>().getData<List<RunningCostOptionModel>>(
      endPoint: 'running_costs',
      fromJson: (json) => (json['data'] as List)
          .map((e) => RunningCostOptionModel.fromJson(e))
          .toList(),
    );
    if (resp is DataSuccess<List<RunningCostOptionModel>>) {
      runningCostOptions = resp.data!;
    }

    runningCostOptionsLoading = false;
    update();
  }

  // NEW
  Future<void> fetchReliefOptionsOnce() async {
    if (reliefOptions.isNotEmpty) return;
    reliefOptionsLoading = true;
    update();
    final resp =
        await Get.find<ApiService>().getData<List<ReliefAssistanceOptionModel>>(
      endPoint: 'relief_assistance_item',
      fromJson: (json) => (json['data'] as List)
          .map((e) => ReliefAssistanceOptionModel.fromJson(e))
          .toList(),
    );
    if (resp is DataSuccess<List<ReliefAssistanceOptionModel>>) {
      reliefOptions = resp.data!;
    }
    reliefOptionsLoading = false;
    update();
  }

  void updateVolunteer(int index, VolunteerItem newItem) {
    if (model == null) return;
    final updated = [...model!.volunteers];
    updated[index] = newItem;
    model = model!.copyWith(volunteers: updated); // ← now persists!
    update();
  }

  final beneficiaryTypes = [
    'Individuals',
    'Family',
    'SARC Staff',
    'SARC Volunteers',
    'SARC Staff and Volunteers'
  ];

  Future<void> init({
    required int planActivityId,
    required String regionType,
    required int regionId,
    required bool isEditable,
  }) async {
    this.planActivityId = planActivityId;
    this.regionType = regionType;
    this.regionId = regionId;
    this.isEditable = isEditable;

    await fetchPlanImplementation();
    await fetchMonths();
    await fetchFacilityTypesOnce();

    // preload both option‐sets exactly once:
    await fetchSalaryOptions("Employee");
    await fetchVolunteerOptionsOnce();
    await fetchEquipmentOptionsOnce();
    await fetchReliefOptionsOnce();
    await fetchRunningCostOptionsOnce();
    await fetchSalaryOptionsOnce();
    await fetchFieldVisitOptionsOnce();
    await fetchTrainingDescriptions();

    update();
  }

  Future<void> fetchSalaryOptionsOnce() async {
    if (salaryOptions.isNotEmpty) return;
    salaryOptionsLoading = true;
    update();

    final list = await fetchSalaryOptions("Employee");
    salaryOptions = list;

    salaryOptionsLoading = false;
    update();
  }

  /// update one row
  void updateRunningCost(int index, RunningCostItem newItem) {
    if (model == null) return;
    final copy = [...model!.runningCosts];
    copy[index] = newItem;
    model = model!.copyWith(runningCosts: copy);
    update();
  }

  void updateReliefItem(int index, ReliefAssistanceItem newItem) {
    if (model == null) return;
    final updated = [...model!.reliefAssistanceItems];
    updated[index] = newItem;
    model = model!.copyWith(reliefAssistanceItems: updated);
    update();
  }

  Future<void> fetchEquipmentOptionsOnce() async {
    if (equipmentOptions.isNotEmpty) return;
    equipmentOptionsLoading = true;
    update();

    final resp =
        await Get.find<ApiService>().getData<List<EquipmentOptionModel>>(
      endPoint: 'equipments',
      fromJson: (json) => (json['data'] as List)
          .map((e) => EquipmentOptionModel.fromJson(e))
          .toList(),
    );

    if (resp is DataSuccess<List<EquipmentOptionModel>>) {
      equipmentOptions = resp.data!;
    }

    equipmentOptionsLoading = false;
    update();
  }

  Future<void> fetchFacilityTypesOnce() async {
    if (facilityTypes.isNotEmpty) return;
    facilityTypesLoading = true;
    update();
    final resp = await Get.find<ApiService>().getData<List<FacilityTypeModel>>(
      endPoint: 'facility_types',
      fromJson: (json) => (json['data'] as List)
          .map((e) => FacilityTypeModel.fromJson(e))
          .toList(),
    );
    if (resp is DataSuccess<List<FacilityTypeModel>>) {
      facilityTypes = resp.data ?? [];
    }
    facilityTypesLoading = false;
    update();
  }

  Future<void> fetchPlanImplementation() async {
    loading = true;
    update();
    final resp = await Get.find<ApiService>().getData<PlanImplementationModel>(
      endPoint: 'plan_implementations',
      queryParameters: {
        'plan_activity_id': planActivityId,
        'region_id': regionId,
        'region_type': regionType,
      },
      fromJson: (json) => PlanImplementationModel.fromJson(json['data'] ?? {}),
    );
    if (resp is DataSuccess<PlanImplementationModel>) {
      model = resp.data;
      selectedMonthsIds = model?.months.map((m) => m.month.id).toList() ?? [];
    }
    loading = false;
    update();
  }

  void updateEquipment(int idx, EquipmentItem e) {
    if (model == null) return;
    final copy = [...model!.equipments];
    copy[idx] = e;
    model = model!.copyWith(equipments: copy);
    update();
  }

  List<SalaryOptionModel> salaryOptions = [];
  bool salaryOptionsLoading = false;

  Future<List<SalaryOptionModel>> fetchSalaryOptions(String type) async {
    // —— CACHING: if we already fetched for this type, just return it.
    if (_salaryOptionsCache.containsKey(type) &&
        _salaryOptionsCache[type]!.isNotEmpty) {
      return _salaryOptionsCache[type]!;
    }

    // otherwise, hit the API once
    final resp = await Get.find<ApiService>().getData<List<SalaryOptionModel>>(
      endPoint: 'salaries',
      queryParameters: {'type': type},
      fromJson: (json) => (json['data'] as List)
          .map((e) => SalaryOptionModel.fromJson(e))
          .toList(),
    );

    final List<SalaryOptionModel> fetched =
        resp is DataSuccess<List<SalaryOptionModel>> ? resp.data ?? [] : [];

    // cache—even if empty, so we don’t refetch repeatedly
    _salaryOptionsCache[type] = fetched;

    return fetched;
  }

  Future<void> fetchVolunteerOptionsOnce() async {
    if (volunteerOptions.isNotEmpty) return;
    volunteerOptionsLoading = true;
    update();
    // reuse same endpoint but filter by type=Volunteer
    final list = await fetchSalaryOptions('Volunteer');
    volunteerOptions = list;
    volunteerOptionsLoading = false;
    update();
  }

  Future<void> fetchMonths() async {
    final resp = await Get.find<ApiService>().getData<MonthsModel>(
      endPoint: 'months',
      fromJson: (json) => MonthsModel.fromJson(json),
    );
    if (resp is DataSuccess<MonthsModel>) {
      allMonths = resp.data?.months ?? [];
      selectedMonthsIds = model?.months.map((m) => m.month.id).toList() ?? [];
      update();
    }
  }

  void toggleMonth(int id) {
    if (selectedMonthsIds.contains(id)) {
      selectedMonthsIds.remove(id);
    } else {
      selectedMonthsIds.add(id);
    }
    update();
  }

  // Setters for fields
  void setTargetType(String? val) {
    if (val != null) model = model?.copyWith(targetType: val);
    update();
  }

  void setTargetNum(int? val) {
    if (val != null) model = model?.copyWith(targetNum: val);
    update();
  }

  void setBeneficiaryType(String? val) {
    if (val != null) model = model?.copyWith(beneficiaryType: val);
    update();
  }

  void setTotalBeneficiaries(int? val) {
    if (val != null) model = model?.copyWith(totalBeneficiaries: val);
    update();
  }

  List<String> validateDraft() {
    final errs = <String>[];

    // ─── top‐level fields ────────────────────────────────────────────
    if ((model?.targetType?.trim().isEmpty ?? true)) {
      errs.add('• Target Type must not be empty.');
    }
    if (model?.targetNum == null || model!.targetNum! <= 0) {
      errs.add('• Target Number must be greater than zero.');
    }
    if ((model?.beneficiaryType?.trim().isEmpty ?? true)) {
      errs.add('• Beneficiary Type must not be empty.');
    }
    if (model?.totalBeneficiaries == null || model!.totalBeneficiaries! <= 0) {
      errs.add('• Total Beneficiaries must be greater than zero.');
    }

    // ─── salaries rows ───────────────────────────────────────────────
    for (var i = 0; i < (model?.salaries?.length ?? 0); i++) {
      final s = model!.salaries![i];
      final row = i + 1;
      if (s.facilityTypeId <= 0) {
        errs.add('• Salary row $row: Facility Type is required.');
      }
      if (s.facilityNameEn.trim().isEmpty) {
        errs.add('• Salary row $row: Facility Name (EN) is required.');
      }
      if (s.facilityNameAr.trim().isEmpty) {
        errs.add('• Salary row $row: Facility Name (AR) is required.');
      }
      if (s.numberOfStaff <= 0) {
        errs.add('• Salary row $row: No. of Staff must be > 0.');
      }
    }

    // ─── volunteer rows ──────────────────────────────────────────────
    for (var i = 0; i < (model?.volunteers.length ?? 0); i++) {
      final v = model!.volunteers[i];
      final row = i + 1;
      if (v.facilityTypeId <= 0) {
        errs.add('• Volunteer row $row: Facility Type is required.');
      }
      if (v.facilityNameEn.trim().isEmpty) {
        errs.add('• Volunteer row $row: Facility Name (EN) is required.');
      }
      if (v.facilityNameAr.trim().isEmpty) {
        errs.add('• Volunteer row $row: Facility Name (AR) is required.');
      }
      if (v.numberOfVolunteers <= 0) {
        errs.add('• Volunteer row $row: No. of Volunteers must be > 0.');
      }
      if (v.numberOfShifts <= 0) {
        errs.add('• Volunteer row $row: No. of Shifts must be > 0.');
      }
    }

    // ─── equipment rows ──────────────────────────────────────────────
    for (var i = 0; i < equipments.length; i++) {
      final e = equipments[i];
      final row = i + 1;
      if (e.facilityTypeId <= 0) {
        errs.add('• Equipment row $row: Facility Type is required.');
      }
      if (e.facilityNameEn.trim().isEmpty) {
        errs.add('• Equipment row $row: Facility Name (EN) is required.');
      }
      if (e.facilityNameAr.trim().isEmpty) {
        errs.add('• Equipment row $row: Facility Name (AR) is required.');
      }
      if (e.equipmentId <= 0) {
        errs.add('• Equipment row $row: Equipment Type is required.');
      }
      if (e.quantity <= 0) {
        errs.add('• Equipment row $row: Quantity must be greater than zero.');
      }
    }

    // ─── relief items rows ───────────────────────────────────────────
    for (var i = 0; i < (model?.reliefAssistanceItems.length ?? 0); i++) {
      final r = model!.reliefAssistanceItems[i];
      final row = i + 1;
      if (r.facilityTypeId <= 0) {
        errs.add('• Relief row $row: Facility Type is required.');
      }
      if (r.facilityNameEn.trim().isEmpty) {
        errs.add('• Relief row $row: Facility Name (EN) is required.');
      }
      if (r.facilityNameAr.trim().isEmpty) {
        errs.add('• Relief row $row: Facility Name (AR) is required.');
      }
      if (r.reliefId <= 0) {
        errs.add('• Relief row $row: Item Type is required.');
      }
      if (r.quantity <= 0) {
        errs.add('• Relief row $row: Quantity must be greater than zero.');
      }
    }

    // ─── running costs rows ──────────────────────────────────────────
    for (var i = 0; i < runningCosts.length; i++) {
      final rc = runningCosts[i];
      final row = i + 1;
      if (rc.facilityTypeId <= 0) {
        errs.add('• Running Cost row $row: Facility Type is required.');
      }
      if (rc.facilityNameEn.trim().isEmpty) {
        errs.add('• Running Cost row $row: Facility Name (EN) is required.');
      }
      if (rc.facilityNameAr.trim().isEmpty) {
        errs.add('• Running Cost row $row: Facility Name (AR) is required.');
      }
      if (rc.runningCostId <= 0) {
        errs.add('• Running Cost row $row: Expense Type is required.');
      }
      // new validation:
      if (rc.description.trim().isEmpty) {
        errs.add(
            '• Running Cost row $row: Expense Description must not be empty.');
      }
      if (rc.numberOfUnitsEveryMonth <= 0) {
        errs.add('• Running Cost row $row: No. of Units must be > 0.');
      }
    }

    // ─── field_visits rows ─────────────────────────────────────────────

    for (var i = 0; i < fieldVisits.length; i++) {
      final fv = fieldVisits[i];
      final row = i + 1;
      if (fv.typeId <= 0) {
        errs.add('• Field Visits row $row: Type is required.');
      }
      if (fv.numOfUnitsPerYear <= 0) {
        errs.add(
            '• Field Visits row $row: Number of travels per year must be > 0.');
      }
      if (fv.specificUnitDay <= 0) {
        errs.add('• Field Visits row $row: Specific Unit/Day must be > 0.');
      }
      if (fv.numberOfUnitsPerTravel <= 0) {
        errs.add(
            '• Field Visits row $row: Number of staff in one travel must be > 0.');
      }
    }
    for (var i = 0; i < trainings.length; i++) {
      final t = trainings[i], row = i + 1;
      if (t.numberOfRequestedTrainings <= 0) {
        errs.add('• Training row $row: Number of requested trainings > 0.');
      }
      if (t.targetedParticipants <= 0) {
        errs.add('• Training row $row: Targeted participants > 0.');
      }
      if (t.numberOfTrainingDays <= 0) {
        errs.add('• Training row $row: Number of training days > 0.');
      }

      for (var j = 0; j < t.trainingCosts.length; j++) {
        final c = t.trainingCosts[j], crow = j + 1;
        if (c.subDescriptionId <= 0) {
          errs.add('• Training $row cost row $crow: Description required.');
        }
        if (c.numberOfUnits <= 0) {
          errs.add('• Training $row cost row $crow: No. of Units > 0.');
        }
        if (c.numberOfDays <= 0) {
          errs.add('• Training $row cost row $crow: No. of Days > 0.');
        }
      }
    }

    return errs;
  }

  void saveDraft() {
    print("draft");
    final jsonMap = {
      "target_type": model?.targetType,
      "target_num": model?.targetNum,
      "beneficiary_type": model?.beneficiaryType,
      "total_beneficiaries": model?.totalBeneficiaries,
      "months_ids": selectedMonthsIds,
      "salaries": model?.salaries?.map((s) => s.toDraftJson()).toList() ?? [],
      "volunteers":
          model?.volunteers.map((v) => v.toDraftJson()).toList() ?? [],
      "equipments": equipments.map((e) => e.toDraftJson()).toList(), // ← new
      "relief_assistance_items":
          model?.reliefAssistanceItems.map((r) => r.toDraftJson()).toList() ??
              [],
      'running_costs': runningCosts.map((r) => r.toDraftJson()).toList(),
      'field_visits': fieldVisits.map((fv) => fv.toDraftJson()).toList(),
      'trainings': trainings.map((t) => t.toDraftJson()).toList(),
    };

    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(jsonMap);
    print(prettyJson);
  }
}
