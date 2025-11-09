import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/features/login/data/model/login_model.dart';
import 'package:food_gpt/features/login/domain/repository/login_repository.dart';
import 'package:food_gpt/features/login/presentation/controller/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepository) : super(const LoginState.initial());
  final LoginRepository _loginRepository;

  Future<void> login(LoginModel loginModel) async {
    emit(LoginState.loading());
    final result = await _loginRepository.login(loginModel: loginModel);
    result.fold(
      (left) {
        emit(LoginState.failure(failure: left));
      },
      (right) {
        emit(LoginState.success(message: right));
      },
    );
  }
}
