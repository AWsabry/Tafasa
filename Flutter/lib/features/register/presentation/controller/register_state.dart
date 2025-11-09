// register_state.dart
import 'package:food_gpt/core/error/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const RegisterState._();
  const factory RegisterState.initial({
    @Default(0) int currentStep,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    @Default(false) bool acceptTerms,
  }) = _Initial;

  const factory RegisterState.loading({
    @Default(0) int currentStep,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    @Default(false) bool acceptTerms,
  }) = _Loading;

  const factory RegisterState.success({
    required String message,
    @Default(0) int currentStep,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    @Default(false) bool acceptTerms,
  }) = _Success;

  const factory RegisterState.failure({
    required Failure failure,
    @Default(0) int currentStep,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    @Default(false) bool acceptTerms,
  }) = _Failure;

  // Custom getters (اختياري)
  bool get isLoading => this is _Loading;
  bool get isSuccess => this is _Success;
  bool get isFailure => this is _Failure;
  bool get isInitial => this is _Initial;
}
