import 'package:dartz/dartz.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/features/register/data/model/register_model.dart';

abstract class RegisterRepository {
  Future<Either<Failure, String>> register(RegisterModel registerModel);
}
