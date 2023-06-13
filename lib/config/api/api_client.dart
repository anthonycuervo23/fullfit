import 'package:dio/dio.dart';

abstract class CustomApiClient {
  late Dio dio;

  CustomApiClient(String baseUrl, {Map<String, dynamic>? headers}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 120000),
        sendTimeout: const Duration(milliseconds: 15000),
      ),
    );
  }

  Future execute<T>(
    Future<Response<dynamic>> request,
    T Function(Map<String, dynamic> json) expecting,
    Future<void> Function(T? entity) completion,
  );

  Future<Response<T>> build<T>(
      {required String endpoint,
      required RequestType requestType,
      dynamic data,
      Map<String, dynamic>? queryParameters}) async {
    return dio.request(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: requestType.method,
    );
  }
}

enum RequestType { get, patch, post }

extension on RequestType {
  Options get method {
    switch (this) {
      case RequestType.get:
        return Options(method: 'GET');
      case RequestType.post:
        return Options(method: 'POST');
      case RequestType.patch:
        return Options(method: 'PATCH');
    }
  }
}
