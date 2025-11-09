import 'package:dartz/dartz.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/features/login/data/model/login_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, String>> login({required LoginModel loginModel});
}
