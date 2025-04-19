import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'data_state.dart';

class TApiService {
  final Dio _dio;

  TApiService(this._dio);

  Future<DataState<T>> getData<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getHeaders(),
        ),
        queryParameters: queryParameters,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> postData<T>({
    dynamic data,
    required String endPoint,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getHeaders(),
        ),
        data: data,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> deleteData<T>({
    dynamic data,
    required String endPoint,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getHeaders(),
        ),
        data: data,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> putData<T>({
    dynamic data,
    required String endPoint,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getHeaders(),
        ),
        data: data,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<String>> postWithoutModel({
    dynamic data,
    required String endPoint,
  }) async {
    try {
      final response = await _dio.post(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getHeaders(),
        ),
        data: data,
      );
      return _handleSimpleResponse(response);
    } on DioException catch (error) {
      return _handleSimpleResponse(error.response);
    }
  }

  Future<DataState<T>> postWithFilesForWeb<T>({
    required String endPoint,
    required Uint8List fileBytes,
    required String fileKey,
    Map<String, dynamic>? formData,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final form = FormData.fromMap({
        ...?formData,
        fileKey: MultipartFile.fromBytes(fileBytes, filename: 'upload.web'),
      });

      final response = await _dio.post(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getMultipartHeaders(),
        ),
        data: form,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<String>> postWithFilesWithoutResponse({
    required String endPoint,
    required Map<String, File> files,
    Map<String, dynamic>? formData,
  }) async {
    try {
      final form = FormData.fromMap({...?formData});

      for (var entry in files.entries) {
        form.files.add(MapEntry(
          entry.key,
          await MultipartFile.fromFile(entry.value.path),
        ));
      }

      final response = await _dio.post(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getMultipartHeaders(),
        ),
        data: form,
      );
      return _handleSimpleResponse(response);
    } on DioException catch (error) {
      return _handleSimpleResponse(error.response);
    }
  }

  Future<DataState<T>> postWithFiles<T>({
    required String endPoint,
    required Map<String, File> files,
    Map<String, dynamic>? formData,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final form = FormData.fromMap({...?formData});

      for (var entry in files.entries) {
        form.files.add(MapEntry(
          entry.key,
          await MultipartFile.fromFile(entry.value.path),
        ));
      }

      final response = await _dio.post(
        TApiConstants.baseUrl + endPoint,
        options: Options(
          headers: _getMultipartHeaders(),
        ),
        data: form,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Map<String, dynamic> _getHeaders() {
    return {
      'Authorization': 'Bearer ${TCacheHelper.getData(key: TKeys.token)}',
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
      if (TCacheHelper.getData(key: TKeys.language) != null)
        'lang': TCacheHelper.getData(key: TKeys.language) == 0 ? 'ar' : 'en',
    };
  }

  Map<String, dynamic> _getMultipartHeaders() {
    return {
      ..._getHeaders(),
      'Content-Type': 'multipart/form-data',
    };
  }

  DataState<String> _handleSimpleResponse(Response? response) {
    if (response != null && response.statusCode == HttpStatus.ok) {
      return DataSuccess('Success');
    }
    return DataFailed(
      Response(
        data: response?.data['error'] ?? 'Unknown error',
        statusCode: response?.statusCode,
        requestOptions: response?.requestOptions ?? RequestOptions(),
      ),
    );
  }

  Future<DataState<T>> handleDataState<T>({
    required Response? response,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    if (response != null) {
      if (response.statusCode == HttpStatus.ok) {
        final object = fromJson(response.data);
        return DataSuccess(object as T);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        TCacheHelper.removeData(key: TKeys.token);
        // Add navigation logic here if needed
      }
    }
    return DataFailed(
      Response(
        data: response?.data['error'] ??
            response?.data['message'] ??
            'Unknown error',
        statusCode: response?.statusCode,
        requestOptions: response?.requestOptions ?? RequestOptions(),
      ),
    );
  }
}