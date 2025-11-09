import 'package:dartz/dartz.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<RecipeModel>>> getAllFavorites();
  Future<Either<Failure, void>> addFavorite(int mealId);
  Future<Either<Failure, void>> removeFavorite(int mealId);
}
