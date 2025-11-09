import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/features/favorites/domain/repository/favorites_repository.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    final result = await _favoritesRepository.getAllFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> removeFavorite(int mealId) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final result = await _favoritesRepository.removeFavorite(mealId);
      result.fold(
        (failure) => emit(FavoritesError(failure.message)),
        (_) {
          final updatedFavorites = currentState.favorites
              .where((meal) => meal.id != mealId)
              .toList();
          emit(FavoritesLoaded(updatedFavorites));
        },
      );
    }
  }

  Future<void> addFavorite(int mealId) async {
    final result = await _favoritesRepository.addFavorite(mealId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => loadFavorites(), // Reload favorites after adding
    );
  }
}
