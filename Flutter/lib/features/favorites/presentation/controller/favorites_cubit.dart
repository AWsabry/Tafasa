import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafasa/features/favorites/domain/repository/favorites_repository.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;
  List<RecipeModel> _allFavorites = [];
  String? _selectedCategory;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    final result = await _favoritesRepository.getAllFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) {
        _allFavorites = favorites;
        _applyFilter();
      },
    );
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilter();
  }

  void _applyFilter() {
    if (_selectedCategory == null || _selectedCategory == 'الكل') {
      emit(FavoritesLoaded(_allFavorites, selectedCategory: _selectedCategory));
    } else {
      final filtered = _allFavorites
          .where((meal) => meal.categoryId.name == _selectedCategory)
          .toList();
      emit(FavoritesLoaded(filtered, selectedCategory: _selectedCategory));
    }
  }

  Future<void> removeFavorite(String mealId) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final result = await _favoritesRepository.removeFavorite(mealId);
      result.fold((failure) => emit(FavoritesError(failure.message)), (_) {
        _allFavorites = _allFavorites
            .where((meal) => meal.mealId != mealId)
            .toList();
        _applyFilter();
        emit(RemoveFavorite());
      });
    }
  }

  Future<void> addFavorite(String mealId) async {
    final result = await _favoritesRepository.addFavorite(mealId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => loadFavorites(), // Reload favorites after adding
    );
  }
}
