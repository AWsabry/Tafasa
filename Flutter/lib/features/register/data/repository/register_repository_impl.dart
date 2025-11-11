import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/core/managers/failure_handler.dart';
import 'package:tafasa/features/register/data/datasource/register_datasource.dart';
import 'package:tafasa/features/register/data/model/register_model.dart';
import 'package:tafasa/features/register/domain/repository/register_repository.dart';

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
