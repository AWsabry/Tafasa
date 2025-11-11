import 'package:dio/dio.dart';
import 'package:tafasa/core/services/api/api_service.dart';
import 'package:tafasa/features/login/data/model/login_model.dart';

class LoginDatasource {
  final DioClient _dioClient;
  LoginDatasource({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Response> login({required LoginModel loginModel}) async {
    return await _dioClient.post("/auth/login", loginModel.toJson());
  }
}
