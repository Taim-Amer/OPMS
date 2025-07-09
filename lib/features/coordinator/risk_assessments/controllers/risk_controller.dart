import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/coordinator/risk_assessments/models/risk_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class RiskController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  // حالات جلب وعملية الإدخال
  RequestState getRiskState = RequestState.begin;
  RequestState insertRiskState = RequestState.begin;

  // البيانات المجلوبة
  RiskModel riskModel = RiskModel.skeleton;

  // خيارات الحقول
  final List<String> years = ['2023', '2024', '2025'];
  final List<String> quarters = ['Q1','Q2','Q3','Q4'];
  final List<String> heavies = ['1', '2', '3', '4', '5'];

  // قيم الحقول
  String? selectedYear;
  String? selectedQuarter;
  String? selectedHeavy;
  int factorId = 0;
  int districtId = 0;
  // String  = '';
  // String  = '';

  @override
  void onInit() {
    super.onInit();
    getRisk();
  }

  Future<void> getRisk() async {
    getRiskState = RequestState.loading;
    update();
    final dataState = await _repo.getRisk();
    if (dataState is DataSuccess) {
      riskModel = dataState.data!;
      getRiskState = (riskModel.data?.isEmpty ?? true)
          ? RequestState.empty
          : RequestState.success;
    } else {
      getRiskState = RequestState.error;
      showSnackBar(
        (dataState as DataFailed).error!.data.toString(),
        AlertState.error,
      );
    }
    update();
  }

  // تحديث الحقول مع إعادة البناء
  void setYear(String? y) {
    selectedYear = y;
    update();
  }

  void setQuarter(String? q) {
    selectedQuarter = q;
    update();
  }

  void setHeavy(String? h) {
    selectedHeavy = h;
    update();
  }

  void setFactorId(int v) {
    factorId = v;
    update();
  }

  void setDistrictId(int v) {
    districtId = v;
    update();
  }

  bool _validate() {
    if (selectedYear == null || selectedQuarter == null || selectedHeavy == null) {
      showSnackBar('Please fill all fields', AlertState.error);
      return false;
    }
    return true;
  }

  Future<void> insertRisk({required int districtID}) async {
    if (!_validate()) return;

    insertRiskState = RequestState.loading;
    update();

    final dataState = await _repo.insertRisk(
      year: selectedYear!,
      quarter: selectedQuarter!,
      factorID: factorId,
      districtID: districtID,
      heavy: int.parse(selectedHeavy!),
    );

    if (dataState is DataSuccess) {
      insertRiskState = RequestState.success;
      showSnackBar('Risk added successfully', AlertState.success);
      await getRisk();
    } else {
      insertRiskState = RequestState.error;
      showSnackBar(
        (dataState as DataFailed).error!.data.toString(),
        AlertState.error,
      );
    }

    update();
  }
}
