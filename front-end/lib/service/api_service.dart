import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ApiService {
  static final Dio dio = Dio();

  // POST request
  static Future<Response?> post(Map<String, dynamic> data, String url) async {
    try {
      var dio = Dio();

      return await dio.post(
        url,
        data: json.encode(data), // Ensure proper JSON encoding
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('API Error: ${e.message}');
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
      }
      return e
          .response; // Still return response to handle specific errors like 409
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      return null;
    }
  }

  // GET request
  static Future<Response?> get(
    String url,
    Map<String, dynamic>? queryParams,
    String token,
  ) async {
    try {
      return await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  // PUT request
  static Future<Response?> put(
    String url,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      return await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  // PATCH request
  static Future<Response?> patch(
    String url,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      return await dio.patch(
        url,
        data: data,
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  // DELETE request
  static Future<Response?> delete(
    String url,
    Map<String, dynamic>? queryParams,
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      return await dio.delete(
        url,
        queryParameters: queryParams,
        data: data,
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }
}
