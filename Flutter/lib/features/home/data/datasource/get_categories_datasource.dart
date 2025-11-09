import 'package:dio/dio.dart';
import 'package:food_gpt/core/services/api/api_service.dart';

class GetCategoriesDatasource {
  final DioClient _dioClient;

  GetCategoriesDatasource(this._dioClient);

  Future<Response> getCategories() async {
    return await _dioClient.get("/categories");
  }
}
