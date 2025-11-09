part of 'suggestions_cubit.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object?> get props => [];
}

class SuggestionsInitial extends SuggestionsState {
  const SuggestionsInitial();
}

class SuggestionsLoading extends SuggestionsState {}

class SuggestionsError extends SuggestionsState {
  final String message;

  const SuggestionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SuggestionsLoaded extends SuggestionsState {
  final Map<String, dynamic> currentMeal;
  final String currentCategory;
  final bool isFavorite;
  final bool isSwipeInProgress;
  final RecipeModel? recipe;

  const SuggestionsLoaded(
    this.currentMeal,
    this.currentCategory, {
    this.isFavorite = false,
    this.isSwipeInProgress = false,
    this.recipe,
  });

  SuggestionsLoaded copyWith({
    Map<String, dynamic>? currentMeal,
    String? currentCategory,
    bool? isFavorite,
    bool? isSwipeInProgress,
    RecipeModel? recipe,
  }) {
    return SuggestionsLoaded(
      currentMeal ?? this.currentMeal,
      currentCategory ?? this.currentCategory,
      isFavorite: isFavorite ?? this.isFavorite,
      isSwipeInProgress: isSwipeInProgress ?? this.isSwipeInProgress,
      recipe: recipe ?? this.recipe,
    );
  }

  @override
  List<Object?> get props => [
    currentMeal,
    currentCategory,
    isFavorite,
    isSwipeInProgress,
    recipe,
  ];
}
