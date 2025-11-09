import 'package:food_gpt/core/error/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState.initial() = _Initial;

  const factory LoginState.loading() = _Loading;

  const factory LoginState.success({required String message}) = _Success;

  const factory LoginState.failure({required Failure failure}) = _Failure;

  bool get isInitial => this is _Initial;
  bool get isSuccess => this is _Success;
  bool get isFailure => this is _Failure;
  bool get isLoading => this is _Loading;
}
