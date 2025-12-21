import 'package:dartz/dartz.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';

abstract class RecipeDetailRepository {
  Future<Either<Failure, RecipeModel>> getRecipeById(String recipeId);
}
