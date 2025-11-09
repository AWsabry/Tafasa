import 'package:dio/dio.dart';
import 'package:food_gpt/core/services/api/api_service.dart';

class FavoritesDatasource {
  final DioClient _dioClient;

  FavoritesDatasource(this._dioClient);

  // Add a meal to favorites
  Future<Response> addFavorite(int mealId) async {
    return await _dioClient.post("/favorites", {"mealId": mealId});
  }

  // Get all favorite meals
  Future<Response> getAllFavorites() async {
    return await _dioClient.get("/favorites");
  }

  // Remove a meal from favorites
  Future<Response> removeFavorite(int mealId) async {
    return await _dioClient.delete("/favorites/$mealId");
  }
}
