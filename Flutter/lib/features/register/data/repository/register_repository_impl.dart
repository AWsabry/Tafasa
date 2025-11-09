import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/core/managers/failure_handler.dart';
import 'package:food_gpt/features/register/data/datasource/register_datasource.dart';
import 'package:food_gpt/features/register/data/model/register_model.dart';
import 'package:food_gpt/features/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDatasource _datasource;

  RegisterRepositoryImpl(this._datasource);
  @override
  Future<Either<Failure, String>> register(RegisterModel registerModel) async {
    try {
      final response = await _datasource.register(registerModel: registerModel);
      return Right(response.data["message"]);
    } on DioException catch (e) {
      return Left(FailureHandler.fromDioError(e));
    }
  }
}
