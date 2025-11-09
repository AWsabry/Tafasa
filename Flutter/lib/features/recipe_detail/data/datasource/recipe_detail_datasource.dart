import 'package:dio/dio.dart';
import 'package:food_gpt/core/services/api/api_service.dart';

class RecipeDetailDatasource {
  final DioClient _dioClient;

  RecipeDetailDatasource(this._dioClient);

  Future<Response> getRecipeById(int mealId) async {
    return await _dioClient.get("/meals/$mealId");
  }
}
