import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafasa/features/recipe_detail/domain/repository/recipe_detail_repository.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';

part 'recipe_detail_state.dart';

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  final RecipeDetailRepository _recipeDetailRepository;

  RecipeDetailCubit(this._recipeDetailRepository)
      : super(const RecipeDetailInitial());

  Future<void> getRecipeDetail(String recipeId) async {
    emit(RecipeDetailLoading());
    final result = await _recipeDetailRepository.getRecipeById(recipeId);
    result.fold(
      (failure) => emit(RecipeDetailError(failure.message)),
      (recipe) => emit(RecipeDetailLoaded(recipe: recipe)),
    );
  }

  void toggleStep(int index) {
    final currentState = state;
    if (currentState is RecipeDetailLoaded) {
      final completedSteps = Set<int>.from(currentState.completedSteps);
      if (completedSteps.contains(index)) {
        completedSteps.remove(index);
      } else {
        completedSteps.add(index);
      }
      emit(currentState.copyWith(completedSteps: completedSteps));
    }
  }
}
