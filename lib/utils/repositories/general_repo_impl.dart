import 'package:get/get.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/repositories/general_repo.dart';

class GeneralRepoImpl implements GeneralRepo{
  final _apiService = Get.find<ApiService>();

  // @override
  // Future<DataState<ExampleModel>> scrapeProduct({required String productUrl, required String storeName}) async{
  //   return await _apiService.getData(
  //     endPoint: ApiConstants.scrapeProduct,
  //     queryParameters: {
  //       'url' : productUrl
  //     },
  //     fromJson: ExampleModel.fromJson,
  //   );
  // }

}