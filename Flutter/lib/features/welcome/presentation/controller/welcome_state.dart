part of 'welcome_cubit.dart';

abstract class WelcomeState extends Equatable {
  const WelcomeState();

  @override
  List<Object?> get props => [];
}

class WelcomeInitial extends WelcomeState {
  const WelcomeInitial();
}

class WelcomeAnimating extends WelcomeState {
  const WelcomeAnimating();
}

class WelcomeLoaded extends WelcomeState {
  const WelcomeLoaded();
}
