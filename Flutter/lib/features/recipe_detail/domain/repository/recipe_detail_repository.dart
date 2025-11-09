import 'package:dartz/dartz.dart';
import 'package:food_gpt/core/error/failure.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';

abstract class RecipeDetailRepository {
  Future<Either<Failure, RecipeModel>> getRecipeById(int recipeId);
}
