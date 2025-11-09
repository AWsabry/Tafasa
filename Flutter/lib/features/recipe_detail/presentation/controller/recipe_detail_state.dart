part of 'recipe_detail_cubit.dart';

abstract class RecipeDetailState extends Equatable {
  const RecipeDetailState();

  @override
  List<Object?> get props => [];
}

class RecipeDetailInitial extends RecipeDetailState {
  const RecipeDetailInitial();
}

class RecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailError extends RecipeDetailState {
  final String message;

  const RecipeDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipeDetailLoaded extends RecipeDetailState {
  final RecipeModel? recipe;
  final Set<int> completedSteps;

  const RecipeDetailLoaded({
    this.recipe,
    this.completedSteps = const {},
  });

  RecipeDetailLoaded copyWith({
    RecipeModel? recipe,
    Set<int>? completedSteps,
  }) {
    return RecipeDetailLoaded(
      recipe: recipe ?? this.recipe,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }

  @override
  List<Object?> get props => [recipe, completedSteps];
}
