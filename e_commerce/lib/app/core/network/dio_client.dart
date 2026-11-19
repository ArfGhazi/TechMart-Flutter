import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_exception.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Future<T> _request<T>(Future<Response<dynamic>> request) async {
    try {
      final response = await request;
      return response.data as T;
    } catch (error) {
      throw ErrorHandler.handle(error).failure;
    }
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) {
    return _request<T>(
      _dio.get<dynamic>(path, queryParameters: queryParameters),
    );
  }

  Future<T> post<T>(String path, {dynamic data}) {
    return _request<T>(_dio.post<dynamic>(path, data: data));
  }

  Future<T> put<T>(String path, {dynamic data}) {
    return _request<T>(_dio.put<dynamic>(path, data: data));
  }
}
