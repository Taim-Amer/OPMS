import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart';
import 'package:opms/utils/api/api_service.dart';

class GlobalRepository {
  final ApiService apiService;

  GlobalRepository(this.apiService);
  Future<Either<String, T>> getData<T>(
      String endpoint,
      T Function(dynamic json) fromJson, {
        String? token,
        String? language,
        Map<String, dynamic>? queryParams, // Optional query parameters
      }) async {
    try {
      final response = await apiService.request(
        endpoint: endpoint,
        method: 'GET',
        token: token,
        language: language,
        queryParams:
        queryParams, // Pass the query parameters to the API service
      );

      return _processResponse(response, fromJson);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  Future<Either<String, T>> deleteData<T>(
      String endpoint,
      T Function(dynamic json) fromJson, {
        String? token,
      }) async {
    try {
      final response = await apiService.request(
        endpoint: endpoint,
        method: 'DELETE',
        token: token,
      );

      return _processResponse(response, fromJson);
    } catch (e) {
      return Left('Error: $e');
    }
  }



  Future<Either<String, T>> postData<T>(
      String endpoint,
      Map<String, dynamic> body,
      T Function(dynamic json) fromJson, {
        String? token,
      }) async {
    try {
      final response = await apiService.request(
        endpoint: endpoint,
        method: 'POST',
        body: body,
        token: token,
      );

      return _processResponse(response, fromJson);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  Future<Either<String, String>> postWithoutModel(
      String endpoint,
      Map<String, dynamic> body, {
        String? token,
      }) async {
    try {
      final response = await apiService.request(
        endpoint: endpoint,
        method: 'POST',
        body: body,
        token: token,
      );

      return _processResponseWithoutData(response);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  Future<Either<String, T>> postWithFilesForWeb<T>(
      String endpoint,
      Map<String, dynamic> body,
      Uint8List? webImageBytes,
      String imageKey,
      T Function(dynamic json) fromJson, {
        String? token,
      }) async {
    try {
      final uri = Uri.parse('${apiService.baseUrl}$endpoint');
      final request = MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add image for web
      if (webImageBytes != null) {
        request.files.add(
          MultipartFile.fromBytes(
            imageKey,
            webImageBytes,
            filename: 'upload.png',
          ),
        );
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedJson = jsonDecode(response.body);
        // Logger.json(decodedJson);
        return Right(fromJson(decodedJson));
      } else {
        final errorMessage = _getErrorMessage(response);
        return Left(errorMessage);
      }
    } catch (e) {
      return Left('Error while making API request: $e');
    }
  }

  Future<Either<String, String>> postWithFilesWithoutResponse(
      String endpoint,
      Map<String, dynamic> body,
      Map<String, File> files, {
        String? token,
      }) async {
    try {
      final response = await apiService.request(
        endpoint: endpoint,
        method: 'POST',
        body: body,
        files: files,
        token: token,
      );
      // Logger.log(response.body);

      return _processResponseWithoutData(response);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  Future<Either<String, T>> postWithFiles<T>(
      String endpoint,
      Map<String, dynamic> body,
      Map<String, File> files,
      T Function(dynamic json) fromJson, {
        String? token,
      }) async {
    try {
      final response = await apiService.request(
        endpoint: endpoint,
        method: 'POST',
        body: body,
        files: files,
        token: token,
      );

      return _processResponse(response, fromJson);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  Either<String, T> _processResponse<T>(
      Response response, T Function(dynamic) fromJson) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedJson = jsonDecode(response.body);
      // Logger.json(decodedJson);
      return Right(fromJson(decodedJson));
    } else if (response.statusCode == 401 &&
        jsonDecode(response.body)["message"] == "Unauthenticated.") {
      // _handleLogoutOnce();
      return const Left("Your session has expired. Please log in again.");
    } else {
      final errorMessage = _getErrorMessage(response);
      return Left(errorMessage);
    }
  }

  Either<String, String> _processResponseWithoutData(Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return const Right('Success');
    } else {
      final errorMessage = _getErrorMessage(response);
      return Left(errorMessage);
    }
  }

  String _getErrorMessage(Response response) {
    try {
      final decodedJson = jsonDecode(response.body);
      return decodedJson['message']?.toString() ?? 'An error occurred'.tr;
    } catch (_) {
      return 'Unknown error'.tr;
    }
  }
}