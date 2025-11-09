import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/core/managers/failure_handler.dart';
import 'package:food_gpt/core/managers/secure_storage.dart';
import 'package:food_gpt/features/login/data/datasource/login_datasource.dart';
import 'package:food_gpt/features/login/data/model/login_model.dart';
import 'package:food_gpt/features/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDatasource _datasource;
  final SecureStorageService _secureStorageService;

  LoginRepositoryImpl(this._datasource, this._secureStorageService);
  @override
  Future<Either<Failure, String>> login({
    required LoginModel loginModel,
  }) async {
    try {
      final response = await _datasource.login(loginModel: loginModel);
      _secureStorageService.write("access_token", response.data["token"]);
      return Right("تم تسجيل الدخول بنجاح");
    } on DioException catch (e) {
      return Left(FailureHandler.fromDioError(e));
    }
  }
}
