import 'package:dio/dio.dart';
import 'package:food_gpt/core/services/api/api_service.dart';

class SuggestionsDatasource {
  final DioClient _dioClient;

  SuggestionsDatasource(this._dioClient);

  Future<Response> getSuggestions({int? categoryId}) async {
    if (categoryId != null) {
      return await _dioClient.get("/categories/$categoryId/recommended");
    } else {
      return await _dioClient.get("/meals/recommended");
    }
  }

  Future<Response> getRandomSuggestion({int? categoryId}) async {
    if (categoryId != null) {
      return await _dioClient.get("/categories/$categoryId/recommended");
    } else {
      return await _dioClient.get("/meals/recommended");
    }
  }
}
