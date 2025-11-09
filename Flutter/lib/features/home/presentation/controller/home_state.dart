part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeCategoriesLoaded extends HomeState {
  final CategoriesResponse categories;

  const HomeCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeIndexChanged extends HomeState {
  final int currentIndex;

  const HomeIndexChanged(this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}
