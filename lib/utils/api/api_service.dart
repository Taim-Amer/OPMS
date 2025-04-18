import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<http.Response> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, File>? files,
    String? token,
    String? language,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (language != null)'lang':language,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final Uri url =
      Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      late http.Response response;

      if (files != null && files.isNotEmpty) {
        final request = http.MultipartRequest(method.toUpperCase(), url);
        request.headers.addAll(headers);

        body?.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        for (var entry in files.entries) {
          request.files.add(await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
            contentType: MediaType('application', 'octet-stream'),
          ));
        }

        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        switch (method.toUpperCase()) {
          case 'POST':
            response =
            await http.post(url, body: jsonEncode(body), headers: headers);
            break;
          case 'PUT':
            response =
            await http.put(url, body: jsonEncode(body), headers: headers);
            break;
          case 'DELETE':
            response = await http.delete(url, headers: headers);
            break;
          case 'GET':
          default:
            response = await http.get(url, headers: headers);
            break;
        }
      }

      return response;
    } catch (e) {
      throw Exception('Error while making API request: $e');
    }
  }
}