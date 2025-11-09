import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/core/utils/logger.dart';
import 'package:food_gpt/features/register/data/model/register_model.dart';
import 'package:food_gpt/features/register/domain/repository/register_repository.dart';
import 'package:food_gpt/features/register/presentation/controller/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _registerRepository;

  RegisterCubit(this._registerRepository)
    : super(const RegisterState.initial());
  void _emitNextStep(RegisterState s) {
    if (s.currentStep < 2) {
      emit(s.copyWith(currentStep: s.currentStep + 1));
    }
  }

  void _emitPreviousStep(RegisterState s) {
    if (s.currentStep > 0) {
      emit(s.copyWith(currentStep: s.currentStep - 1));
    }
  }

  void nextStep() {
    state.maybeMap(
      initial: (initialState) => _emitNextStep(initialState),
      failure: (value) => _emitNextStep(value),
      orElse: () {},
    );
  }

  void previousStep() {
    state.maybeMap(
      initial: (initialState) => _emitPreviousStep(initialState),
      failure: (value) => _emitPreviousStep(value),
      orElse: () {
        Logger.debug(state.toString());
      },
    );
  }

  void togglePasswordVisibility() {
    state.maybeMap(
      initial: (initialState) {
        emit(
          initialState.copyWith(obscurePassword: !initialState.obscurePassword),
        );
      },
      orElse: () {},
    );
  }

  void toggleConfirmPasswordVisibility() {
    state.maybeMap(
      initial: (initialState) {
        emit(
          initialState.copyWith(
            obscureConfirmPassword: !initialState.obscureConfirmPassword,
          ),
        );
      },
      orElse: () {},
    );
  }

  void updateTermsAcceptance(bool accept) {
    state.maybeMap(
      initial: (initialState) {
        emit(initialState.copyWith(acceptTerms: accept));
      },
      orElse: () {},
    );
  }

  Future<void> register(RegisterModel registerModel) async {
    // حفظ الـ state الحالي
    final currentState = state;

    emit(
      RegisterState.loading(
        currentStep: currentState.currentStep,
        obscurePassword: currentState.obscurePassword,
        obscureConfirmPassword: currentState.obscureConfirmPassword,
        acceptTerms: currentState.acceptTerms,
      ),
    );

    final result = await _registerRepository.register(registerModel);

    result.fold(
      (failure) {
        emit(
          RegisterState.failure(
            failure: failure,
            currentStep: currentState.currentStep,
            obscurePassword: currentState.obscurePassword,
            obscureConfirmPassword: currentState.obscureConfirmPassword,
            acceptTerms: currentState.acceptTerms,
          ),
        );
        emit(
          RegisterState.initial(
            currentStep: currentState.currentStep,
            obscurePassword: currentState.obscurePassword,
            obscureConfirmPassword: currentState.obscureConfirmPassword,
            acceptTerms: currentState.acceptTerms,
          ),
        );
      },
      (message) {
        emit(
          RegisterState.success(
            message: message,
            currentStep: currentState.currentStep,
            obscurePassword: currentState.obscurePassword,
            obscureConfirmPassword: currentState.obscureConfirmPassword,
            acceptTerms: currentState.acceptTerms,
          ),
        );
        emit(
          RegisterState.initial(
            currentStep: currentState.currentStep,
            obscurePassword: currentState.obscurePassword,
            obscureConfirmPassword: currentState.obscureConfirmPassword,
            acceptTerms: currentState.acceptTerms,
          ),
        );
      },
    );
  }
}
