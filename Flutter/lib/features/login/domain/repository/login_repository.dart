import 'package:dartz/dartz.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/features/login/data/model/login_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, String>> login({required LoginModel loginModel});
}
