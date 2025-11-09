import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';
import 'package:food_gpt/features/suggestions/domain/repository/suggestions_repository.dart';

part 'suggestions_state.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  final SuggestionsRepository _suggestionsRepository;
  final int? _initialCategoryId;

  SuggestionsCubit(this._suggestionsRepository, {int? categoryId})
    : _initialCategoryId = categoryId,
      super(const SuggestionsInitial()) {
    _loadInitialMeal();
  }

  Future<void> _loadInitialMeal() async {
    emit(SuggestionsLoading());
    final result = await _suggestionsRepository.getRandomSuggestion(
      categoryId: _initialCategoryId,
    );
    result.fold(
      (failure) => emit(SuggestionsError(failure.message)),
      (recipe) => emit(
        SuggestionsLoaded(
          recipe.toMealMap(),
          recipe.categoryId.name,
          recipe: recipe,
        ),
      ),
    );
  }

  Future<void> suggestNewMeal(String? excludeMealName) async {
    final currentState = state;
    if (currentState is SuggestionsLoaded) {
      emit(SuggestionsLoading());
      final result = await _suggestionsRepository.getRandomSuggestion(
        categoryId: _initialCategoryId,
      );
      result.fold(
        (failure) => emit(SuggestionsError(failure.message)),
        (recipe) => emit(
          SuggestionsLoaded(
            recipe.toMealMap(),
            recipe.categoryId.name,
            isFavorite: false,
            recipe: recipe,
          ),
        ),
      );
    }
  }

  void setFavorite(bool isFavorite) {
    final currentState = state;
    if (currentState is SuggestionsLoaded) {
      emit(currentState.copyWith(isFavorite: isFavorite));
    }
  }

  void setSwipeInProgress(bool inProgress) {
    final currentState = state;
    if (currentState is SuggestionsLoaded) {
      emit(currentState.copyWith(isSwipeInProgress: inProgress));
    }
  }
}
