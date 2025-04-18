import 'dart:convert';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class TDioHelper {
  static final TDioHelper _instance = TDioHelper._internal();
  late Dio dio;

  factory TDioHelper() {
    return _instance;
  }

  TDioHelper._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: TApiConstants.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
    dio.interceptors.add(PrettyDioLogger(requestBody: true, error: true, requestHeader: true));
  }

  // Future<Map<String, dynamic>> get(String endPoint, {String lang = 'en', String? token}) async {
  //   dio.options.headers = {
  //     'Content-Type': 'application/json',
  //     'lang': lang,
  //     'Authorization': token != null ? 'Bearer $token' : '',
  //   };
  //
  //   final response = await dio.get(endPoint);
  //   return _handleResponse(response);
  // }

  Future<Map<String, dynamic>> get(String endPoint, {String lang = 'en', String? token, Map<String, dynamic>? queryParameters}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token != null ? 'Bearer $token' : '',
    };

    final response = await dio.get(endPoint, queryParameters: queryParameters);
    return _handleResponse(response);
  }


  Future<Map<String, dynamic>> post(String endPoint, Map<String, dynamic> data, {String lang = 'en', String? token}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token != null ? 'Bearer $token' : '',
    };

    final response = await dio.post(endPoint, data: data);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endPoint, Map<String, dynamic> data, {String lang = 'en', String? token}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };

    final response = await dio.put(endPoint, data: data);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endPoint, {String lang = 'en', String? token}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };

    final response = await dio.delete(endPoint);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200) {
      if (response.data == null || response.data.isEmpty) {
        throw Exception("Received empty response body");
      }
      return response.data is Map ? response.data : json.decode(response.data);
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
}
