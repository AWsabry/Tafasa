import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(const WelcomeInitial());

  void startAnimation() {
    emit(const WelcomeAnimating());
  }

  void completeAnimation() {
    emit(const WelcomeLoaded());
  }
}
