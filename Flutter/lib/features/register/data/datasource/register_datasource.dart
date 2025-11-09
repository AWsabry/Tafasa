import 'package:dio/dio.dart';
import 'package:food_gpt/core/services/api/api_service.dart';
import 'package:food_gpt/features/register/data/model/register_model.dart';

class RegisterDatasource {
  final DioClient _dioClient;

  RegisterDatasource({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Response> register({required RegisterModel registerModel}) async {
    return await _dioClient.post("/auth/register", registerModel.toJson());
  }
}
