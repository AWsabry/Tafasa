import 'package:dio/dio.dart';
import 'package:tafasa/core/services/api/api_service.dart';

class SuggestionsDatasource {
  final DioClient _dioClient;

  SuggestionsDatasource(this._dioClient);

  Future<Response> getSuggestions({String? categoryId}) async {
    if (categoryId != null) {
      return await _dioClient.get("/categories/$categoryId/recommended");
    } else {
      return await _dioClient.get("/meals/recommended");
    }
  }

  Future<Response> getRandomSuggestion({String? categoryId}) async {
    if (categoryId != null) {
      return await _dioClient.get("/categories/$categoryId/recommended");
    } else {
      return await _dioClient.get("/meals/recommended");
    }
  }
}
