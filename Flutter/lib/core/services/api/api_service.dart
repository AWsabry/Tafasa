import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_gpt/core/utils/logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final String baseUrl = "http://192.168.137.1:5000";
  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          Logger.error("❌ Dio Error", e, StackTrace.current);
          handler.next(e);
        },
      ),
    );
  }

  final storage = const FlutterSecureStorage();

  Future<String?> _getAccessToken() => storage.read(key: "access_token");

  // ------------------------- METHODS -------------------------

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? query}) async {
    final url = '$baseUrl$endpoint';
    Logger.log('Making GET request to: $url');

    try {
      final response = await dio.get(endpoint, queryParameters: query);
      Logger.log('✅ GET successful: $url');
      return response;
    } on DioException catch (e, stackTrace) {
      Logger.error('❌ GET failed: $url', e, stackTrace);
      rethrow;
    }
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic>? data, {
    FormData? formData,
  }) async {
    final url = '$baseUrl$endpoint';
    Logger.log('Making POST request to: $url');

    try {
      final response = await dio.post(endpoint, data: formData ?? data);
      Logger.log('✅ POST successful: $url');
      return response;
    } on DioException catch (e, stackTrace) {
      Logger.error('❌ POST failed: $url', e, stackTrace);
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async {
    final url = '$baseUrl$endpoint';
    Logger.log('Making PUT request to: $url');

    try {
      final response = await dio.put(endpoint, data: data);
      Logger.log('✅ PUT successful: $url');
      return response;
    } on DioException catch (e, stackTrace) {
      Logger.error('❌ PUT failed: $url', e, stackTrace);
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final url = '$baseUrl$endpoint';
    Logger.log('Making DELETE request to: $url');

    try {
      final response = await dio.delete(endpoint);
      Logger.log('✅ DELETE successful: $url');
      return response;
    } on DioException catch (e, stackTrace) {
      Logger.error('❌ DELETE failed: $url', e, stackTrace);
      rethrow;
    }
  }
}
