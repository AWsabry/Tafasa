import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/core/utils/logger.dart';
import 'package:food_gpt/features/home/data/model/categories_model.dart';
import 'package:food_gpt/features/home/domain/repository/get_categories_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesRepository _getCategoriesRepository;

  HomeCubit(this._getCategoriesRepository) : super(const HomeInitial());

  void setCurrentIndex(int index) {
    final currentState = state;
    emit(HomeIndexChanged(index));
    emit(currentState);
  }

  void resetIndex() {
    final currentState = state;

    emit(const HomeIndexChanged(0));
    emit(currentState);
  }

  Future<void> getCategories() async {
    try {
      emit(HomeLoading());
      final result = await _getCategoriesRepository.getCategories();
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (categories) => emit(HomeCategoriesLoaded(categories)),
      );
    } catch (e) {
      Logger.debug(e.toString());
    }
  }
}
