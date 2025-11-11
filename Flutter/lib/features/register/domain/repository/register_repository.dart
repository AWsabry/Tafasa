import 'package:dartz/dartz.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/features/register/data/model/register_model.dart';

abstract class RegisterRepository {
  Future<Either<Failure, String>> register(RegisterModel registerModel);
}
