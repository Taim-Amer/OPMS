import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/coordinator/home/model/home_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class HomeController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getHomeState = RequestState.begin;
  HomeModel homeModel = HomeModel.skeleton;


  int currentPage = 1;
  int perPage = 10;
  int totalPages = 1;

  String? quarter;
  String? year;

  @override
  void onInit() {
    getHome();
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<HomeController>();
    super.onClose();
  }

  Future<void> getHome({
    int? governorateID,
    int? page,
    int? perPageOverride,
  }) async {
    currentPage = page ?? currentPage;
    final usedPerPage = perPageOverride ?? perPage;

    getHomeState = RequestState.loading;
    update();

    final response = await _repo.getHome(
      page: currentPage,
      perPage: usedPerPage,
      paginate: true,
      quarter: quarter,
      year: year,
    );

    if (response is DataSuccess) {
      homeModel = response.data!;
      totalPages = response.data!.meta?.lastPage ?? 1;

      if ((homeModel.data?.isEmpty ?? true)) {
        getHomeState = RequestState.empty;
      } else {
        getHomeState = RequestState.success;
      }
    } else {
      getHomeState = RequestState.error;
      showSnackBar(
        (response as DataFailed).error!.data.toString(),
        AlertState.error,
      );
    }
    update();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    getHome(
      page: page,
    );
  }

  void nextPage() => goToPage(currentPage + 1);
  void prevPage() => goToPage(currentPage - 1);
}