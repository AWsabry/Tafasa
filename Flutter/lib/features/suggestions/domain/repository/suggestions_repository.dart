import 'package:dartz/dartz.dart';
import 'package:tafasa/core/error/failure.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';

abstract class SuggestionsRepository {
  Future<Either<Failure, SuggestionsResponse>> getSuggestions({
    String? categoryId,
  });

  Future<Either<Failure, RecipeModel>> getRandomSuggestion({
    String? categoryId,
  });
}
